//
//  SettingsView.swift
//  BubblePopPop
//
//  Created by 牙后慧 on 2025/4/21.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var gameSettings: GameSettings
    @State private var timerInput: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Top bar
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .shadow(radius: 2)
                
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Text("Settings")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // Empty view for balance
                    Text("")
                        .padding(.trailing)
                }
            }
            .frame(height: 60)
            
            // Settings content
            Form {
                Section(header: Text("Game Timer")) {
                    TextField("Timer duration (seconds)", text: $timerInput)
                        .keyboardType(.numberPad)
                        .onAppear {
                            timerInput = "\(gameSettings.timerDuration)"
                        }
                }
                
                Button("Save") {
                    if let newDuration = Int(timerInput), newDuration > 0 {
                        gameSettings.timerDuration = newDuration
                    } else {
                        // Reset to default if invalid
                        timerInput = "\(gameSettings.timerDuration)"
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationBarHidden(true)
    }
}
