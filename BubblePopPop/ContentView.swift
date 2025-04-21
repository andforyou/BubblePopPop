//
//  ContentView.swift
//  BubblePopPop
//
//  Created by 牙后慧 on 2025/4/20.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var gameSettings = GameSettings()
    @State private var showGameView = false
    
    var body: some View {
        Group {
            if showGameView || !gameSettings.playerName.isEmpty {
                // Show game view if user has already entered name or just entered it
                GameView(gameSettings: gameSettings)
            } else {
                // Show welcome view for new users
                WelcomeView(gameSettings: gameSettings) {
                    showGameView = true
                }
            }
        }
    }
}
