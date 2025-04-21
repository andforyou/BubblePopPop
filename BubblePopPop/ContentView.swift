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
            if showGameView {
                // Show game view once user has entered name
                GameView(gameSettings: gameSettings)
            } else {
                // Always show welcome view first
                WelcomeView(gameSettings: gameSettings) {
                    showGameView = true
                }
            }
        }
    }
}
