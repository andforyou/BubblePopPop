import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var gameSettings: GameSettings
    @State private var timerInput: String = ""
    @State private var maxBubblesInput: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Top bar
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .shadow(radius: 2)
                
                HStack {
                    Button(action: {
                        dismiss()
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
                    HStack {
                        Text("Game Duration (seconds)")
                        Spacer()
                        TextField("60", text: $timerInput)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                    
                    // Note about valid values
                    Text("Please enter a value between 10 and 120 seconds")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Section(header: Text("Maximum Bubbles")) {
                    HStack {
                        Text("Max Bubbles")
                        Spacer()
                        TextField("15", text: $maxBubblesInput)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                    
                    // Note about valid values
                    Text("Please enter a value between 5 and 30 bubbles")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Section {
                    Button("Save Settings") {
                        saveSettings()
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.blue)
                }
            }
            .padding(.top)
        }
        .navigationBarHidden(true)
        .onAppear {
            timerInput = "\(gameSettings.timerDuration)"
            maxBubblesInput = "\(gameSettings.maxBubbles)"
        }
    }
    
    // Save settings with validation
    private func saveSettings() {
        if let newDuration = Int(timerInput), newDuration >= 10 && newDuration <= 120 {
            gameSettings.timerDuration = newDuration
        } else {
            // Reset to default if invalid
            timerInput = "\(gameSettings.timerDuration)"
        }
        
        if let newMaxBubbles = Int(maxBubblesInput), newMaxBubbles >= 5 && newMaxBubbles <= 30 {
            gameSettings.maxBubbles = newMaxBubbles
        } else {
            // Reset to default if invalid
            maxBubblesInput = "\(gameSettings.maxBubbles)"
        }
    }
}
