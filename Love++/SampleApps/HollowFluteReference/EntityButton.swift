import SwiftUI
import WatchKit

// MARK: - EntityButton
// This component handles the entity button for consciousness transformation
// It manages its own visual state including golden glow on press and image switching

struct EntityButton: View {
    // MARK: - Button Configuration
    // These properties define the button's behavior and appearance
    
    /// Primary action triggered by tap gesture (consciousness transformation)
    /// Receives a completion callback when animation finishes
    let action: (@escaping () -> Void) -> Void
    
    /// Secondary action triggered by long-press gesture (blood drop transformation)
    /// Receives a completion callback when animation finishes
    let secondAction: (@escaping () -> Void) -> Void
    
    /// Default entity image to display
    let entityImage: String
    
    /// Image to show when button is pressed (e.g., "KrishnaPlaying")
    let pressedImage: String
    
    /// Size of the button for proper scaling
    let size: CGFloat
    
    /// Current love count for transformation check
    let currentLoveCount: Int
    
    /// Whether the button is currently being pressed
    @State private var isPressed = false
    
    var body: some View {
        ZStack {
            // MARK: - Entity Image
            // The entity image that changes based on interaction state
            // Only show pressed image when transformation is possible
            Image((isPressed && currentLoveCount > 0) ? pressedImage : entityImage)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .scaleEffect(isPressed ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isPressed)
            

        }
        .frame(width: size, height: size)
        .contentShape(Circle())
        .shadow(color: (isPressed && currentLoveCount > 0) ? Color.transformationOrange.opacity(0.9) : .clear, radius: 20, x: 0, y: 0)
        .shadow(color: (isPressed && currentLoveCount > 0) ? Color.transformationOrange.opacity(0.7) : .clear, radius: 35, x: 0, y: 0)
        .simultaneousGesture(
            // MARK: - Tap Gesture
            // Primary interaction for consciousness transformation
            TapGesture()
                .onEnded { _ in
                    handleTap()
                }
        )
        .simultaneousGesture(
            // MARK: - Long Press Gesture
            // Secondary interaction for blood drop transformation
            LongPressGesture(minimumDuration: 0.5)
                .onEnded { _ in
                    handleLongPress()
                }
        )
    }
    
    // MARK: - Gesture Handlers
    // These functions manage the sacred button interactions
    
    /// Handles tap gestures for primary consciousness transformation actions
    /// Creates beautiful golden glow effect and triggers transformation
    private func handleTap() {
        if !isPressed {
            isPressed = true
            
            // Call action with completion callback
            action {
                // Animation complete, now safe to reset pressed state
                isPressed = false
            }
        }
    }
    
    /// Handles long-press gestures for secondary blood drop transformation actions
    /// Enables advanced transformation patterns and deep consciousness work
    private func handleLongPress() {
        secondAction {
            // Long press action complete
        }
    }
}

// MARK: - Preview
// Shows the EntityButton in action

#Preview {
    EntityButton(
        action: { completion in 
            print("Consciousness transformation triggered")
            completion()
        },
        secondAction: { completion in 
            print("Blood drop transformation triggered")
            completion()
        },
        entityImage: "Krishna",
        pressedImage: "KrishnaPlaying",
        size: 100,
        currentLoveCount: 5
    )
    .padding(20)
    .background(Color.black)
}
