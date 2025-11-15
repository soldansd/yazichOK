//
//  RecordingView.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 05/04/2025.
//

import SwiftUI
import Lottie

struct RecordingView: View {
    
    @StateObject var recordingVM: RecordingViewModel
    @EnvironmentObject var coordinator: HomeCoordinator
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThickMaterial)
                .ignoresSafeArea()
            
            CellCard {
                sound
                questionNumberText
                questionText
                circleTimer
                
                HStack(spacing: 16) {
                    resetButton
                    
                    if recordingVM.isRecording {
                        pauseButton
                    } else {
                        startButton
                    }
                    
                    if recordingVM.currentQuestionNumber == recordingVM.countOfQuestions, !recordingVM.elapsedTime.isZero, !recordingVM.isRecording
                        {
                        
                        if let session = recordingVM.session {
                            Button {
                                coordinator.push(.assesmentResults(sessionId: session.id))
                            } label: {
                                checkmark
                            }
                            .simultaneousGesture(
                                TapGesture().onEnded {
                                    Task {
                                        await recordingVM.saveRecord()
                                    }
                                }
                            )
                        } else {
                            Rectangle()
                                .fill(.background)
                                .frame(width: 40, height: 40)
                        }
                        
                    } else {
                        nextQuestionButton
                    }
                        
                }
                
                if let error = recordingVM.errorMessage {
                    Text(error)
                }
            }
            .padding(.horizontal)
            
        }
        .task {
            await recordingVM.loadSession()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButtonToolbar {
                    coordinator.pop()
                }
            }
        }
    }
    
    private var sound: some View {
        Circle()
            .frame(width: 50, height: 50)
            .foregroundStyle(.pastelBlue)
            .overlay {
                LottieView(animation: .named("sound"))
                    .playbackMode(
                        recordingVM.isRecording
                        ? .playing(.fromFrame(1, toFrame: 33, loopMode: .loop))
                        : .paused
                    )
            }
    }
    
    private var questionNumberText: some View {
        Text("Question \(recordingVM.currentQuestionNumber) of \(recordingVM.countOfQuestions)")
    }
    
    private var questionText: some View {
        Text(recordingVM.currentQuestion?.text ?? "")
            .padding(.horizontal)
    }
    
    private var circleTimer: some View {
        ProgressCircleBar(
            progress: $recordingVM.progress,
            color: .darkBlue
        )
        .frame(width: 60, height: 60)
        .overlay {
            Text("\(Int(recordingVM.elapsedTime))/\(Int(recordingVM.maxDuration))")
                .font(.footnote)
        }
    }
    
    private var resetButton: some View {
        Button {
            recordingVM.resetRecording()
        } label: {
            reset
        }
        .disabled(recordingVM.isRecording || recordingVM.elapsedTime.isZero)
    }
    
    private var pauseButton: some View {
        Button {
            recordingVM.pauseRecording()
        } label: {
            pauseFill
        }
    }
    
    private var startButton: some View {
        Button {
            recordingVM.startRecording()
        } label: {
            microphoneFill
        }
        .disabled(recordingVM.elapsedTime >= recordingVM.maxDuration)
    }
    
    private var nextQuestionButton: some View {
        Button {
            recordingVM.nextQuestion()
            Task {
                await recordingVM.saveRecord()
            }
        } label: {
            checkmark
        }
        .disabled(recordingVM.elapsedTime.isZero || recordingVM.isRecording)
    }
    
    private var reset: some View {
        Circle()
            .frame(width: 40, height: 40)
            .foregroundStyle(.regularMaterial)
            .overlay {
                Image(systemName: "arrow.trianglehead.counterclockwise")
            }
    }
    
    private var pauseFill: some View {
        Circle()
            .frame(width: 54, height: 54)
            .foregroundStyle(.darkBlue)
            .overlay {
                Image(systemName: "pause.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .padding(12)
            }
    }
    
    private var microphoneFill: some View {
        Circle()
            .frame(width: 52, height: 52)
            .foregroundStyle(recordingVM.elapsedTime >= recordingVM.maxDuration ? .gray : .darkBlue)
            .overlay {
                Image(systemName: "microphone.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .padding(12)
            }
    }
    
    private var checkmark: some View {
        Circle()
            .frame(width: 40, height: 40)
            .foregroundStyle(.regularMaterial)
            .overlay {
                Image(systemName: "checkmark")
            }
    }
}

#Preview {
    NavigationStack {
        RecordingView(recordingVM: RecordingViewModel(topicId: 1))
    }
}
