import SwiftUI

// MARK: - LoveButton
// This component handles the sacred 123 button for love download
// It combines HolyNumberView styling with gesture handling for a complete love download experience

struct LoveButton: View {
    // MARK: - Button Configuration
    // These properties define the button's behavior
    
    /// Primary action triggered by tap gesture (love download)
    let action: () -> Void
    
    /// Secondary action triggered by long-press gesture (blood drop)
    let secondAction: () -> Void
    
    /// Size of the button for proper scaling
    let size: CGFloat
    
    // MARK: - Button State
    // Tracks whether the button is currently being tapped
    
    @State private var isTapped = false
    
    var body: some View {
        ZStack {
            // MARK: - Sacred Button Background
            // The button background uses the sacred Krishna background image
            // and includes beautiful gradient borders for divine aesthetics
            Circle()
                .fill(
                    ImagePaint(
                        image: Image("KrishnaBG"),
                        scale: 1.0
                    )
                )
                .overlay(
                    // Primary border with sacred gradient
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.black.opacity(0.5),
                                    Color.black.opacity(0.3),
                                    Color.white.opacity(0.1),
                                    Color.white.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3.0
                        )
                )
                .overlay(
                    // Secondary border with blur effect for depth
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.black.opacity(0.4),
                                    Color.clear,
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 4.0
                        )
                        .blur(radius: 3)
                        .offset(x: 1, y: 1)
                )
                .shadow(color: .white.opacity(0.2), radius: 2, x: -1, y: -1)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
            
            // MARK: - Sacred 123 Button Content
            // HolyNumberView provides the beautiful golden styling and animations
            HolyNumberView(size: size)
                .frame(width: size * 0.7, height: size * 0.7)
                .aspectRatio(1, contentMode: .fit)
                .scaleEffect(isTapped ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isTapped)
        }
        .frame(width: size, height: size)
        .contentShape(Circle())
        .shadow(color: Color.transformationOrange.opacity(0.8), radius: 15, x: 0, y: 0)
        .shadow(color: Color.transformationOrange.opacity(0.6), radius: 25, x: 0, y: 0)
        .simultaneousGesture(
            // MARK: - Tap Gesture
            // Primary interaction for love download
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
    
    /// Handles tap gestures for primary love download actions
    /// Creates satisfying visual feedback and triggers love download
    private func handleTap() {
        if !isTapped {
            isTapped = true
            action()
            
            // Reset tap state after animation completes
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isTapped = false
            }
        }
    }
    
    /// Handles long-press gestures for secondary blood drop actions
    /// Enables advanced transformation patterns and deep consciousness work
    private func handleLongPress() {
        secondAction()
    }
}

// MARK: - Preview
// Shows the LoveButton in action

#Preview {
    LoveButton(
        action: { print("Love download triggered") },
        secondAction: { print("Blood drop transformation triggered") },
        size: 80
    )
    .padding(20)
    .background(
        Image("KrishnaBG")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    )
}
