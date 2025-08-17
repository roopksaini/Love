import AVFoundation
import WatchKit

// MARK: - SoundManager
// This component manages sacred sounds that enhance consciousness transformation
// Each sound represents a different aspect of the spiritual journey and serves
// to create the sacred atmosphere necessary for consciousness coding.

public class SoundManager: NSObject {
    // MARK: - Singleton Pattern
    // Shared instance for global access to sacred sounds
    
    public static let shared = SoundManager()
    
    // MARK: - Audio Session
    // Manages device audio behavior for optimal sacred sound playback
    
    private var audioSession: AVAudioSession
    
    // MARK: - Active Players
    // Dynamic arrays to hold active audio players for simultaneous sounds
    
    private var activePlayers: [AVAudioPlayer] = []
    
    // MARK: - Initialization
    // Sets up the audio session and cleanup timer for sacred sound management
    
    private override init() {
        audioSession = AVAudioSession.sharedInstance()
        super.init()
        setupAudioSession()
        setupCleanupTimer()
    }
    
    // MARK: - Audio Session Setup
    // Configures the device audio session for optimal sacred sound playback
    
    /// Sets up the audio session for sacred sounds
    /// This ensures proper audio routing and behavior
    private func setupAudioSession() {
        do {
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
            print("✅ Audio session configured for sacred sounds")
        } catch {
            print("❌ Failed to configure audio session: \(error)")
        }
    }
    
    // MARK: - Cleanup Timer
    // Periodically cleans up finished audio players to maintain performance
    
    /// Sets up a timer to clean up finished audio players
    /// This ensures optimal performance and memory management
    private func setupCleanupTimer() {
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.cleanupFinishedPlayers()
        }
    }
    
    // MARK: - Player Cleanup
    // Removes audio players that have finished playing
    
    /// Removes players that have finished playing
    /// This maintains optimal performance and memory usage
    private func cleanupFinishedPlayers() {
        activePlayers.removeAll { player in
            !player.isPlaying
        }
    }
    
    // MARK: - Player Creation
    // Creates audio players for specific sound files
    
    /// Creates an audio player for a specific sound file
    /// - Parameter filename: Name of the sound file to load
    /// - Returns: Configured AVAudioPlayer or nil if creation fails
    private func createPlayer(for filename: String) -> AVAudioPlayer? {
        guard let url = Bundle.main.url(forResource: filename.components(separatedBy: ".").first, 
                                      withExtension: filename.components(separatedBy: ".").last) else {
            print("❌ Could not find sound file: \(filename)")
            return nil
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            print("✅ Successfully created player for: \(filename)")
            return player
        } catch {
            print("❌ Could not create audio player for \(filename): \(error)")
            return nil
        }
    }
    
    // MARK: - Sound Playback
    // Core function for playing sacred sounds
    
    /// Plays a specific sound file with proper player management
    /// - Parameter filename: Name of the sound file to play
    private func playSound(filename: String) {
        if let player = createPlayer(for: filename) {
            // Add to active players for lifecycle management
            activePlayers.append(player)
            
            // Play the sacred sound
            let success = player.play()
            print("🎵 \(filename) sound play attempt - success: \(success)")
            
            // Set up completion handler to remove from active players
            player.delegate = self
        }
    }
    
    // MARK: - Sacred Sound Methods
    // These methods provide access to specific sacred sounds for consciousness coding
    
    /// Plays the sacred flute sound for consciousness transformation
    /// This represents the moment when consciousness is elevated
    public func playFluteSound() {
        playSound(filename: "flute-charm.mp3")
    }
    
    /// Plays the sun sound for love download
    /// This represents grace descending from the cosmos
    public func playSunSound() {
        playSound(filename: "love-drop.mp3")
    }
    
    /// Plays the blood drop sound for deep transformation
    /// This represents profound consciousness change and healing
    public func playBloodSound() {
        playSound(filename: "blood-drop.mp3")
    }
    
    /// Plays the empty flute sound for guidance
    /// This guides users when no love is available for transformation
    public func playEmptyFluteSound() {
        playSound(filename: "whoosh.mp3")
    }
}

// MARK: - AVAudioPlayerDelegate
// Handles audio player lifecycle events for proper cleanup

extension SoundManager: AVAudioPlayerDelegate {
    /// Called when an audio player finishes playing
    /// Removes the player from active players for cleanup
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let index = activePlayers.firstIndex(of: player) {
            activePlayers.remove(at: index)
        }
    }
}

// MARK: - Preview Helper
// Helper class for SwiftUI previews

class PreviewSoundManager: SoundManager {
    override init() {
        super.init()
        // Set up preview data
    }
}

// MARK: - Preview
// Shows the SoundManager in action

#Preview {
    VStack(spacing: 20) {
        Text("Sound Manager Demo")
            .font(.title)
            .foregroundStyle(.golden)

        Text("Ready to play sacred sounds!")
            .font(.subheadline)
            .foregroundStyle(.white.opacity(0.8))
    }
    .padding()
    .background(Color.black)
}
