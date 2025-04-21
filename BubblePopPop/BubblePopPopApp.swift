//
//  BubblePopPopApp.swift
//  BubblePopPop
//
//  Created by 牙后慧 on 2025/4/20.
//

import SwiftUI

@main
struct BubblePopApp: App {
    @StateObject private var gameSettings = GameSettings()
    
    var body: some Scene {
        WindowGroup {
            GameView()
        }
    }
}
