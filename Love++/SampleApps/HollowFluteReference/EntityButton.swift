import SwiftUI
import WatchKit

// MARK: - EntityButton
// This component handles the entity button for consciousness transformation
// It manages its own visual state including golden glow on press and image switching

struct EntityButton: View {
    // MARK: - Button Configuration
    // These properties define the button's behavior and appearance
    
    /// Primary action triggered by tap gesture (consciousness transformation)
    let action: () -> Void
    
    /// Secondary action triggered by long-press gesture (blood drop transformation)
    let secondAction: () -> Void
    
    /// Default entity image to display
    let entityImage: String
    
    /// Image to show when button is pressed (e.g., "KrishnaPlaying")
    let pressedImage: String
    
    /// Size of the button for proper scaling
    let size: CGFloat
    
    /// Whether the button is currently being pressed
    @State private var isPressed = false
    
    var body: some View {
        ZStack {
            // MARK: - Entity Image
            // The entity image that changes based on interaction state
            Image(isPressed ? pressedImage : entityImage)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .scaleEffect(isPressed ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isPressed)
            

        }
        .frame(width: size, height: size)
        .contentShape(Circle())
        .shadow(color: isPressed ? Color.transformationOrange.opacity(0.9) : .clear, radius: 20, x: 0, y: 0)
        .shadow(color: isPressed ? Color.transformationOrange.opacity(0.7) : .clear, radius: 35, x: 0, y: 0)
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
            action()
            
            // Reset pressed state after animation completes
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                isPressed = false
            }
        }
    }
    
    /// Handles long-press gestures for secondary blood drop transformation actions
    /// Enables advanced transformation patterns and deep consciousness work
    private func handleLongPress() {
        secondAction()
    }
}

// MARK: - Preview
// Shows the EntityButton in action

#Preview {
    EntityButton(
        action: { print("Consciousness transformation triggered") },
        secondAction: { print("Blood drop transformation triggered") },
        entityImage: "Krishna",
        pressedImage: "KrishnaPlaying",
        size: 100
    )
    .padding(20)
    .background(Color.black)
}
