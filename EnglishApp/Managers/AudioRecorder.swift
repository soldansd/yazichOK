import Foundation
import AVFoundation

final class AudioRecorder {
    
    static let shared = AudioRecorder()
    
    private let session = AVAudioSession.sharedInstance()
    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    private(set) var recordedFileURL: URL?
    
    private init() {}
    
    func requestPermissionAndRecord() {
        session.requestRecordPermission { granted in
            if granted {
                self.startRecording()
            } else {
                print("Microphone permission denied")
            }
        }
    }
    
    func startRecording() {
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try session.setActive(true)
        } catch {
            print("Cannot activate session: \(error.localizedDescription)")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let fileName = "\(dateFormatter.string(from: Date())).m4a"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        print("Saving to: \(fileURL)")
        recordedFileURL = fileURL  // Save the file path for playback
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderBitRateKey: 96000,
            AVLinearPCMBitDepthKey: 16,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            recorder = try AVAudioRecorder(url: fileURL, settings: settings)
            recorder?.prepareToRecord()
            recorder?.record()
        } catch {
            print("Cannot record audio: \(error.localizedDescription)")
        }
    }
    
    func pauseRecording() {
        guard recorder?.isRecording == true else {
            print("Recorder is not currently recording")
            return
        }
        recorder?.pause()
        print("Recording paused")
    }
    
    func resumeRecording() {
        guard let recorder, !recorder.isRecording else {
            print("Recorder is already recording or not initialized")
            return
        }
        recorder.record()
        print("Recording resumed")
    }
    
    func stopRecording() {
        recorder?.stop()
        recorder = nil
        do {
            try session.setActive(false)
        } catch {
            print("Error deactivating session: \(error.localizedDescription)")
        }
    }
    
    func playRecording() {
        guard let fileURL = recordedFileURL else {
            print("No recording available")
            return
        }
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            print("File does not exist: \(fileURL)")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: fileURL)
            player?.play()
        } catch {
            print("Cannot play audio: \(error.localizedDescription)")
        }
    }
}
