//
//  ContentView.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 28/03/2025.
//

import SwiftUI

struct ContentView: View {
    
    let recorder = AudioRecorder.shared
    
    var body: some View {
        VStack(spacing: 32) {
            Button {
                recorder.requestPermissionAndRecord()
            } label: {
                Text("Start")
            }
            
            Button {
                recorder.stopRecording()
            } label: {
                Text("Stop")
            }
            
            Button {
                recorder.playRecording()
            } label: {
                Text("Play")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
