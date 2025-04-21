//
//  Bubble.swift
//  BubblePopPop
//
//  Created by 牙后慧 on 2025/4/20.
//

import SwiftUI

// Bubble colors and their probabilities
enum BubbleColor: CaseIterable {
    case red, pink, green, blue, black
    
    // Get the actual Color
    var color: Color {
        switch self {
        case .red: return Color(red: 242/255, green: 0/255, blue: 6/255)
        case .pink: return Color(red: 244/255, green: 170/255, blue: 185/255)
        case .green: return .green
        case .blue: return .blue
        case .black: return .black
        }
    }
    
    // Get the point value for this bubble color
    var points: Int {
        switch self {
        case .red: return 1
        case .pink: return 2
        case .green: return 5
        case .blue: return 8
        case .black: return 10
        }
    }
    
    // Random color based on probability
    static func random() -> BubbleColor {
        let randomValue = Double.random(in: 0...1)
        
        // Use the probability distribution from the documentation
        switch randomValue {
        case 0..<0.4:  // 40% probability
            return .red
        case 0.4..<0.7:  // 30% probability
            return .pink
        case 0.7..<0.85:  // 15% probability
            return .green
        case 0.85..<0.95:  // 10% probability
            return .blue
        default:  // 5% probability
            return .black
        }
    }
}

// Bubble model
struct Bubble: Identifiable {
    let id = UUID()
    let position: CGPoint
    let size: CGFloat
    let bubbleColor: BubbleColor
    
    // Generate a random bubble within screen bounds
    static func random(in bounds: CGRect) -> Bubble {
        let diameter = CGFloat.random(in: 40...80)
        // Adjust position to ensure bubble is fully within bounds
        let x = CGFloat.random(in: (0 + diameter/2)...(bounds.width - diameter/2))
        let y = CGFloat.random(in: (0 + diameter/2)...(bounds.height - diameter/2))
        
        return Bubble(
            position: CGPoint(x: x, y: y),
            size: diameter,
            bubbleColor: BubbleColor.random()
        )
    }
}
