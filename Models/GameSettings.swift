//
//  GameSettings.swift
//  BubblePopPop
//
//  Created by 牙后慧 on 2025/4/21.
//

import SwiftUI
import Combine

class GameSettings: ObservableObject {
    @Published var timerDuration: Int = 60
}
