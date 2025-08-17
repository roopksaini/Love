import SwiftUI

// MARK: - FloatingEmoji
// This component handles the sacred visual transformation of consciousness
// It creates beautiful floating elements that show the 1💗I → 1💗1 transformation
// through complex animations including blood drops, musical notes, and love flows.

struct FloatingEmoji: View {
    // MARK: - Element Configuration
    // These properties define what type of transformation is occurring
    
    /// The text to display and transform (e.g., "1💗", "💗I")
    let text: String
    
    /// Starting position for the floating element
    let startPosition: CGPoint
    
    /// Destination position for love drops (flows to entity)
    let destination: CGPoint?
    
    /// Whether this is a blood drop transformation (deep consciousness work)
    let isBloodDrop: Bool
    
    /// Whether this is a musical note transformation (consciousness elevation)
    let isMusicalNote: Bool
    
    /// Available height for positioning calculations
    let availableHeight: CGFloat

    // MARK: - Animation States
    // These states control the complex transformation animations
    
    /// Horizontal offset for floating movement
    @State private var xOffset: CGFloat = 0
    
    /// Vertical offset for floating movement
    @State private var yOffset: CGFloat = 0
    
    /// Overall opacity of the element
    @State private var opacity: Double = 1.0
    
    /// Text opacity for transformation effects
    @State private var textOpacity: Double = 1.0
    
    /// Scale effect for visual impact
    @State private var scale: CGFloat = 1.0
    
    /// Rotation effect for dynamic movement
    @State private var rotation: Double = 0
    
    /// Whether the element is currently animating
    @State private var isAnimating = false
    
    /// Whether to show the transformed text (I → 1)
    @State private var showTransformedText = false
    
    var body: some View {
        // MARK: - Text Components
        // Parse the text into prefix, heart, and suffix for transformation
        let components = textComponents
        
        HStack(spacing: 0) {
            // MARK: - Prefix Text (usually "1")
            // This represents the divine source or unity
            if !components.prefix.isEmpty {
                Text(components.prefix)
                    .font(.system(size: 40, weight: .semibold, design: .serif))
                    .opacity(textOpacity)
                    .foregroundStyle(
                        components.prefix == "1" 
                        ? Color.transformationOrange : Color(red: 0.1, green: 0.25, blue: 0.5)
                    )
                    .shadow(color: Color(red: 0.15, green: 0.35, blue: 0.6).opacity(0.5), radius: 2)
            }
            
            // MARK: - Heart Symbol (💗)
            // This represents divine love and the transformative force
            if !components.heart.isEmpty {
                Text(components.heart)
                    .font(.system(size: 46))
            }
            
            // MARK: - Suffix Text (usually "I" that becomes "1")
            // This is where the sacred transformation occurs
            if !components.suffix.isEmpty {
                ZStack {
                    // Original text (scales down and fades out)
                    Text(components.suffix)
                        .font(.system(size: 40, weight: .semibold, design: .serif))
                        .opacity(textOpacity * (showTransformedText ? 0 : 1))
                        .scaleEffect(showTransformedText ? 0.3 : 1.0)
                        .foregroundStyle(
                            components.suffix == "I" 
                            ? .black : (components.suffix == "1" 
                            ? Color.transformationOrange : Color(red: 0.1, green: 0.25, blue: 0.5))
                        )
                        .shadow(color: Color(red: 0.15, green: 0.35, blue: 0.6).opacity(0.5), radius: 2)
                    
                    // Transformed text (scales up and fades in)
                    // This is the sacred I → 1 transformation
                    if isMusicalNote && components.suffix == "I" {
                        Text("1")
                            .font(.system(size: 40, weight: .semibold, design: .serif))
                            .opacity(textOpacity * (showTransformedText ? 1 : 0))
                            .scaleEffect(showTransformedText ? 1.0 : 0.3)
                            .foregroundStyle(Color.transformationOrange)
                            .shadow(color: Color(red: 0.15, green: 0.35, blue: 0.6).opacity(0.5), radius: 2)
                    }
                }
            }
        }
        .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
        .position(x: startPosition.x + xOffset, 
                 y: startPosition.y + yOffset)
        .opacity(opacity)
        .scaleEffect(scale)
        .rotationEffect(.degrees(rotation))
        .onChange(of: isAnimating) { _, newValue in
            guard newValue else { return }
            animate()
        }
        .onAppear {
            isAnimating = true
        }
    }

    // MARK: - Text Parsing
    // Parses the text into components for transformation
    
    /// Parses the text into prefix, heart, and suffix components
    /// This enables the sacred transformation from "I" to "1"
    private var textComponents: (prefix: String, heart: String, suffix: String) {
        let parts = text.components(separatedBy: "💗")
        if isBloodDrop {
            // For blood drops, use the text exactly as provided
            if parts.count > 1 {
                return (parts[0], "💗", parts[1])  // For "1💗" or "💗I"
            } else {
                return ("", "💗", "")  // Fallback for just "💗"
            }
        } else {
            // For regular animations
            if parts[0].isEmpty {
                return ("", "💗", parts.count > 1 ? parts[1] : "")
            } else {
                return (parts[0], "💗", "")
            }
        }
    }

    // MARK: - Animation Orchestration
    // This function determines which animation to play based on element type
    
    /// Determines and executes the appropriate animation for this element
    /// Each animation type represents a different aspect of consciousness transformation
    private func animate() {
        if isBloodDrop {
            animateBloodDrop()
        } else if isMusicalNote {
            animateMusicalNote()
        } else if let dest = destination {
            animateToDestination(dest)
        } else {
            animateSunEffect()
        }
    }
    
    // MARK: - Blood Drop Animation
    // Represents deep consciousness transformation and healing
    
    /// Animates blood drop elements for deep consciousness work
    /// This represents profound transformation and healing
    private func animateBloodDrop() {
        // Start with full opacity for both the text and heart
        opacity = 1.0
        textOpacity = 1.0  // Make sure text is visible
        scale = 1.0
        
        // Simple, elegant downward motion with slight deceleration
        withAnimation(
            .timingCurve(0.4, 0, 0.2, 1.0, duration: 1.2)
        ) {
            yOffset = 200
            scale = 0.95
        }
        
        // Fade out near the end of the drop
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation(.easeOut(duration: 0.3)) {
                opacity = 0
                textOpacity = 0  // Fade out text along with heart
            }
        }
    }
    
    // MARK: - Musical Note Animation
    // Represents consciousness elevation and the sacred I → 1 transformation
    
    /// Animates musical note elements for consciousness elevation
    /// This is where the sacred I → 1 transformation occurs
    private func animateMusicalNote() {
        // Complex floating animation with random movement
        withAnimation(.easeInOut(duration: 2.0)) {
            xOffset = CGFloat.random(in: -100 ... 100)
            yOffset = CGFloat.random(in: -200 ... -50)
            rotation = Double.random(in: -45 ... 45)
            opacity = 0
            scale = 1.4
        }
        
        // Text opacity animation for visual impact
        withAnimation(
            .easeInOut(duration: 0.8)
            .repeatCount(3, autoreverses: true)
        ) {
            textOpacity = 1.0
        }
        
        // Trigger the magical transformation
        // This is the sacred moment when "I" becomes "1"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeInOut(duration: 0.6)) {
                showTransformedText = true
            }
        }
    }
    
    // MARK: - Destination Animation
    // Represents love drops flowing to the entity
    
    /// Animates elements flowing to a specific destination
    /// This represents love drops flowing to the entity for transformation
    private func animateToDestination(_ dest: CGPoint) {
        // Animate to the destination (e.g., center of bottom button)
        withAnimation(.timingCurve(0.4, 0, 0.2, 1.0, duration: 1.2)) {
            xOffset = dest.x - startPosition.x
            yOffset = dest.y - startPosition.y
            scale = 1.0
        }
        
        // Fade out at destination
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation(.easeOut(duration: 0.3)) {
                opacity = 0
                textOpacity = 0
            }
        }
    }
    
    // MARK: - Sun Effect Animation
    // Represents love download from the cosmos
    
    /// Animates sun effect elements for love download
    /// This represents grace descending from the cosmos
    private func animateSunEffect() {
        // Start with both text and heart visible
        textOpacity = 1.0
        
        // Gentler drop animation
        withAnimation(
            .timingCurve(0.2, 0.8, 0.2, 1.0, duration: 0.8)  // Softer curve, longer duration
        ) {
            xOffset = 0
            yOffset = 80
        }
        
        // Adjust fade timing to match new duration
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeOut(duration: 0.3)) {
                opacity = 0
                textOpacity = 0
            }
        }
    }
}

// MARK: - Color Extension
// The sacred golden color used throughout the consciousness coding system

extension Color {
    static let transformationOrange = Color(red: 255/255, green: 225/255, blue: 85/255)
}

// MARK: - Preview
// Shows the FloatingEmoji in action
#Preview {
    FloatingEmoji(
        text: "💗I",
        startPosition: CGPoint(x: 100, y: 100),
        destination: nil,
        isBloodDrop: false,
        isMusicalNote: true,
        availableHeight: 200
    )
    .frame(width: 200, height: 200)
    .background(Color.black)
}
