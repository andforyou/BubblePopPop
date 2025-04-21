import SwiftUI

// Main game view
struct GameView: View {
    @ObservedObject var gameSettings: GameSettings
    @StateObject private var scoreManager = ScoreManager()
    @State private var bubbles: [Bubble] = []
    @State private var screenBounds: CGRect = .zero
    @State private var timeRemaining: Int = 60
    @State private var isGameActive: Bool = true
    @State private var showSettings: Bool = false
    @State private var showHighScores: Bool = false
    @State private var showPointEarned: Bool = false
    @State private var lastPointsEarned: Int = 0
    @State private var lastPointPosition: CGPoint = .zero
    
    // Timer to add new bubbles
    let bubbleTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    // Game countdown timer
    let gameTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 0) {
            // Fixed Timer Bar at top
            ZStack {
                // Timer background
                Rectangle()
                    .fill(Color.white)
                    .shadow(radius: 2)
                
                HStack {
                    // Player name display (left)
                    Text(gameSettings.playerName)
                        .font(.title)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    // Timer display (middle)
                    Text("Time: \(timeRemaining)")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // Score display (right)
                    Text("Score: \(scoreManager.currentScore)")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // Settings button
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "gear")
                            .font(.title2)
                    }
                    .padding(.trailing)
                }
                .padding(.horizontal)
            }
            .frame(height: 60)
            .zIndex(1) // Ensure timer is always on top
            
            // Game Area
            ZStack {
                // Background
                Color(red: 0.9, green: 0.9, blue: 0.95)
                    .edgesIgnoringSafeArea(.all)
                
                // Game over message
                if !isGameActive {
                    VStack {
                        Text("Game Over!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                        
                        Text("Total Score: \(scoreManager.currentScore)")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top)
                        
                        Button(action: {
                            // Save score and show high scores
                            scoreManager.saveScore(playerName: gameSettings.playerName)
                            showHighScores = true
                        }) {
                            Text("View High Scores")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.top, 30)
                        
                        Button(action: {
                            resetGame()
                        }) {
                            Text("Play Again")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        .padding(.top, 10)
                    }
                    .zIndex(2) // Ensure it's visible above bubbles
                }
                
                // Bubbles
                if isGameActive {
                    ForEach(bubbles) { bubble in
                        Circle()
                            .fill(bubble.bubbleColor.color)
                            .frame(width: bubble.size, height: bubble.size)
                            .position(bubble.position)
                            .shadow(color: .gray.opacity(0.3), radius: 2, x: 1, y: 1)
                            .onTapGesture {
                                // Remove the tapped bubble and add points
                                if let index = bubbles.firstIndex(where: { $0.id == bubble.id }) {
                                    let pointsEarned = scoreManager.bubblePopped(color: bubble.bubbleColor)
                                    lastPointsEarned = pointsEarned
                                    lastPointPosition = bubble.position
                                    showPointEarned = true
                                    
                                    // Hide the points after a short delay
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        showPointEarned = false
                                    }
                                    
                                    bubbles.remove(at: index)
                                }
                            }
                    }
                    
                    // Display points earned animation
                    if showPointEarned {
                        Text("+\(lastPointsEarned)")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(8)
                            .position(lastPointPosition)
                            .transition(.scale.combined(with: .opacity))
                            .zIndex(3)
                    }
                }
            }
        }
        .background(
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        self.screenBounds = geometry.frame(in: .global)
                        // Initialize with some bubbles
                        self.generateInitialBubbles()
                        // Set initial time from settings
                        self.timeRemaining = gameSettings.timerDuration
                        // Reset score for new game
                        self.scoreManager.resetScore()
                    }
            }
        )
        .onReceive(bubbleTimer) { _ in
            if isGameActive {
                self.refreshBubbles()
            }
        }
        .onReceive(gameTimer) { _ in
            if isGameActive {
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    // End the game
                    isGameActive = false
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(gameSettings: gameSettings)
        }
        .sheet(isPresented: $showHighScores) {
            HighScoreView(scoreManager: scoreManager)
        }
        .onChange(of: showSettings) { oldValue, newValue in
            if newValue == false {
                // Settings sheet was dismissed, update the timer
                timeRemaining = gameSettings.timerDuration
                isGameActive = true
                // Reset score for new game
                scoreManager.resetScore()
            }
        }
        .onChange(of: showHighScores) { oldValue, newValue in
            if newValue == false {
                // High score sheet was dismissed, restart the game
                resetGame()
            }
        }
    }
    
    // Generate initial set of bubbles
    private func generateInitialBubbles() {
        // Start with 10 bubbles
        for _ in 0..<10 {
            self.addRandomBubble()
        }
    }
    
    // Add a random bubble that doesn't overlap with existing ones
    private func addRandomBubble() {
        guard !screenBounds.isEmpty else { return }
        
        // Try up to 10 times to find a position without overlap
        for _ in 0..<10 {
            let newBubble = Bubble.random(in: screenBounds)
            
            // Check for overlap
            if !bubbles.contains(where: { existingBubble in
                let distance = sqrt(
                    pow(existingBubble.position.x - newBubble.position.x, 2) +
                    pow(existingBubble.position.y - newBubble.position.y, 2)
                )
                return distance < (existingBubble.size/2 + newBubble.size/2)
            }) {
                // No overlap found, add the bubble
                bubbles.append(newBubble)
                return
            }
        }
    }
    
    // Refresh bubbles (remove some, add some new ones)
    private func refreshBubbles() {
        // Remove 30-70% of existing bubbles
        let removalCount = Int.random(in: 3...7) * bubbles.count / 10
        bubbles.removeFirst(min(removalCount, bubbles.count))
        
        // Add new bubbles (respecting the max bubbles setting)
        let maxBubblesToAdd = gameSettings.maxBubbles - bubbles.count
        if maxBubblesToAdd > 0 {
            let newBubbleCount = min(Int.random(in: 3...5), maxBubblesToAdd)
            for _ in 0..<newBubbleCount {
                addRandomBubble()
            }
        }
    }
    
    // Reset game
    func resetGame() {
        timeRemaining = gameSettings.timerDuration
        bubbles = []
        generateInitialBubbles()
        isGameActive = true
        scoreManager.resetScore()
    }
}
