//
//  NetworkManager.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 03/04/2025.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let baseURL = "https://2f6e-194-99-105-90.ngrok-free.app"
    
    private init() {}
    
    func getTopics() async throws -> [TopicDTO] {
        let response = await AF.request("\(baseURL)/topics").serializingData().response
        
        let topicsResponse = try await decodeResponse(response, successType: TopicsResponse.self)
        return topicsResponse.data.topics
    }
    
    func getRecordingSession(id: Int) async throws -> RecordingSessionDTO {
        let topicID = TopicID(id: id)
        
        let response = await AF.request(
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

            AF.upload(multipartFormData: { multipartFormData in
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
        let response = await AF.request("\(baseURL)/sessions/\(id.uuidString)/complete", method: .post).serializingData().response
        
        let assesmentResultsResponse = try await decodeResponse(response, successType: AssesmentResultsResponse.self)
        return assesmentResultsResponse.data
    }
    
    func loadArticlesPreview(limit: Int, offset: Int) async throws -> [ArticlePreviewDTO] {
        let response = await AF.request("\(baseURL)/articles?limit=\(limit)&offset=\(offset)").serializingData().response
        
        let articlesResponse = try await decodeResponse(response, successType: ArticlesPreviewResponse.self)
        return articlesResponse.data.articles
    }
    
    func getArticle(id: Int) async throws -> ArticleDTO {
        let response = await AF.request("\(baseURL)/articles/\(id)").serializingData().response
        
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
            guard statusCode == 200 else {
                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                throw errorResponse.error
            }
            
            return try JSONDecoder().decode(successType, from: data)
        case .failure(let error):
            throw error
        }
    }
    
}
