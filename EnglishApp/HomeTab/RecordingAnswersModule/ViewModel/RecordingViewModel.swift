//
//  RecordingViewModel.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 05/04/2025.
//

import Foundation

@MainActor
class RecordingViewModel: ObservableObject {

    let topicID: Int

    @Published var currentQuestion: Question?
    @Published var errorMessage: String?
    @Published var progress: Double = 0.0
    @Published var isRecording: Bool = false
    @Published var isLoadingSession: Bool = false
    @Published var isUploadingAudio: Bool = false

    private var timer: Timer?
    private(set) var elapsedTime: TimeInterval = 0
    let maxDuration: TimeInterval = 30
    
    private(set) var session: RecordingSession? {
        didSet {
            currentQuestion = session?.topicQuestions.questions.first
        }
    }
    
    var currentQuestionNumber: Int {
        guard
            let currentQuestion,
            let index = session?.topicQuestions.questions.firstIndex(of: currentQuestion)
        else { return 0 }
        
        return index + 1
    }
    
    var countOfQuestions: Int {
        guard let session else { return 0 }
        return session.topicQuestions.questions.count
    }
    
    init(topicId: Int) {
        self.topicID = topicId
    }
    
    func nextQuestion() {
        guard let session, let currentQuestion else { return }
        let questions = session.topicQuestions.questions
        let currentIndex = questions.firstIndex(of: currentQuestion)
        guard let currentIndex else { return }
        if currentIndex == (questions.count - 1) {
            
        } else {
            self.currentQuestion = questions[currentIndex + 1]
        }
    }
    
    func resetRecording() {
        stopTimer()
        resetTimer()
        AudioRecorder.shared.stopRecording()
    }
    
    func startRecording() {
        startTimer()
        AudioRecorder.shared.startRecording()
    }
    
    func pauseRecording() {
        stopTimer()
        AudioRecorder.shared.pauseRecording()
    }
    
    func resumeRecording() {
        startTimer()
        AudioRecorder.shared.resumeRecording()
    }
    
    func saveRecord() async {
        resetRecording()
        guard
            let fileURL = AudioRecorder.shared.recordedFileURL,
            let session,
            let currentQuestion
        else { return }

        isUploadingAudio = true
        errorMessage = nil

        do {
            try await NetworkManager.shared.uploadAudioFile(fileURL: fileURL, sessionID: session.id, questionID: currentQuestion.id)
            errorMessage = nil
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
            print("Upload file error: \(error.localizedDescription)")
        } catch {
            errorMessage = "Upload failed: \(error.localizedDescription)"
            print("Upload file error: \(error.localizedDescription)")
        }

        isUploadingAudio = false
    }

    func loadSession() async {
        isLoadingSession = true
        errorMessage = nil

        do {
            let fetchedSession = try await NetworkManager.shared.getRecordingSession(id: topicID)
            session = fetchedSession.toModel()
            errorMessage = nil
        } catch let error as APIError {
            errorMessage = "Error \(error.code): \(error.message)"
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Unexpected error: \(error.localizedDescription)"
        }

        isLoadingSession = false
    }
    
    private func startTimer() {
        timer = Timer(timeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                self.elapsedTime += 0.1
                self.progress = min(self.elapsedTime / self.maxDuration, 1.0)
                if self.elapsedTime >= self.maxDuration {
                    self.pauseRecording()
                }
            }
        }
        guard let timer else { return }
        RunLoop.main.add(timer, forMode: .common)
        isRecording = true
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRecording = false
    }
    
    private func resetTimer() {
        elapsedTime = 0
        progress = 0.0
    }

    deinit {
        // Clean up timer to prevent memory leaks
        timer?.invalidate()
        timer = nil

        // Stop any active recording
        AudioRecorder.shared.stopRecording()
    }

}
