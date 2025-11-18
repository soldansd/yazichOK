//
//  NetworkManager.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 03/04/2025.
//

import Foundation
import Alamofire

// MARK: - Custom Retry Policy

private class CustomRetryPolicy: RetryPolicy {
    override init(
        retryLimit: UInt = 3,
        exponentialBackoffBase: UInt = 2,
        exponentialBackoffScale: Double = 0.5,
        retryableHTTPMethods: Set<HTTPMethod> = [.get, .post, .put, .delete, .patch],
        retryableHTTPStatusCodes: Set<Int> = Set(500...599),
        retryableURLErrorCodes: Set<URLError.Code> = [
            .timedOut,
            .cannotConnectToHost,
            .networkConnectionLost,
            .dnsLookupFailed,
            .notConnectedToInternet
        ]
    ) {
        super.init(
            retryLimit: retryLimit,
            exponentialBackoffBase: exponentialBackoffBase,
            exponentialBackoffScale: exponentialBackoffScale,
            retryableHTTPMethods: retryableHTTPMethods,
            retryableHTTPStatusCodes: retryableHTTPStatusCodes,
            retryableURLErrorCodes: retryableURLErrorCodes
        )
    }
}

// MARK: - Network Manager

final class NetworkManager {

    static let shared = NetworkManager()

    private let baseURL: String
    private let session: Session

    private init() {
        // Use configuration-based URL
        self.baseURL = AppConfiguration.baseURL

        // Configure custom session with timeout
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = AppConfiguration.requestTimeout
        configuration.timeoutIntervalForResource = AppConfiguration.requestTimeout * 2

        // Configure retry policy
        let interceptor = Interceptor(
            retryPolicy: CustomRetryPolicy()
        )

        self.session = Session(
            configuration: configuration,
            interceptor: interceptor
        )
    }
    
    func getTopics() async throws -> [TopicDTO] {
        let response = await session.request("\(baseURL)/topics").serializingData().response

        let topicsResponse = try await decodeResponse(response, successType: TopicsResponse.self)
        return topicsResponse.data.topics
    }
    
    func getRecordingSession(id: Int) async throws -> RecordingSessionDTO {
        let topicID = TopicID(id: id)

        let response = await session.request(
            "\(baseURL)/sessions",
            method: .post,
            parameters: topicID,
            encoder: JSONParameterEncoder.default
        ).serializingData().response

        let sessionResponse = try await decodeResponse(response, successType: SessionResponse.self)
        return sessionResponse.data.session
    }
    
    func uploadAudioFile(fileURL: URL, sessionID: UUID, questionID: Int) async throws {

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in

            session.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(fileURL, withName: "answer", fileName: fileURL.lastPathComponent, mimeType: "audio/m4a")
                multipartFormData.append(Data("\(questionID)".utf8), withName: "questionID")
            }, to: "\(baseURL)/sessions/\(sessionID)/answer", method: .post)
            .uploadProgress { progress in
                let progressPercentage = progress.fractionCompleted * 100
                print(String(format: "Upload Progress: %.2f%%", progressPercentage))
            }
            .response { response in
                if let error = response.error {
                    print("File upload error: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                } else if let statusCode = response.response?.statusCode, (200...299).contains(statusCode) {
                    print("File uploaded successfully.")
                    continuation.resume()
                } else {
                    let error = NSError(domain: "UploadError", code: response.response?.statusCode ?? 500, userInfo: nil)
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func completeRecordingSession(id: UUID) async throws -> SpeakingAssessmentResultsDTO {
        let response = await session.request("\(baseURL)/sessions/\(id.uuidString)/complete", method: .post).serializingData().response

        let assesmentResultsResponse = try await decodeResponse(response, successType: AssesmentResultsResponse.self)
        return assesmentResultsResponse.data
    }

    func loadArticlesPreview(limit: Int, offset: Int) async throws -> [ArticlePreviewDTO] {
        let response = await session.request("\(baseURL)/articles?limit=\(limit)&offset=\(offset)").serializingData().response

        let articlesResponse = try await decodeResponse(response, successType: ArticlesPreviewResponse.self)
        return articlesResponse.data.articles
    }

    func getArticle(id: Int) async throws -> ArticleDTO {
        let response = await session.request("\(baseURL)/articles/\(id)").serializingData().response

        let articleResponse = try await decodeResponse(response, successType: ArticleResponse.self)
        return articleResponse.data.article
    }
    
    private func decodeResponse<T: Decodable>(
        _ response: DataResponse<Data, AFError>,
        successType: T.Type
    ) async throws -> T {

        guard let statusCode = response.response?.statusCode else {
            throw NetworkError.badServerResponse
        }

        switch response.result {
        case .success(let data):
            // Accept all 2xx status codes as success
            guard (200...299).contains(statusCode) else {
                // Try to decode API error response
                if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    throw errorResponse.error
                }
                // Fallback to generic network error
                throw NetworkError.httpError(statusCode: statusCode)
            }

            return try JSONDecoder().decode(successType, from: data)
        case .failure(let error):
            // Map AFError to appropriate NetworkError
            throw mapAFError(error)
        }
    }

    private func mapAFError(_ error: AFError) -> Error {
        switch error {
        case .sessionTaskFailed(let urlError as URLError):
            switch urlError.code {
            case .timedOut:
                return NetworkError.timeout
            case .notConnectedToInternet, .networkConnectionLost:
                return NetworkError.noConnection
            default:
                return NetworkError.connectionFailed(urlError)
            }
        default:
            return error
        }
    }

}
