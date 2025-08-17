import SwiftUI

// MARK: - HolyNumberView
// This component represents the sacred 123 button - the gateway for downloading divine love
// It features beautiful golden animations that represent the living, breathing nature
// of divine consciousness and the sacred rhythm of love accumulation.

struct HolyNumberView: View {
    // MARK: - Component Configuration
    // The size of the sacred 123 button determines its visual impact
    
    let size: CGFloat
    
    // MARK: - Animation States
    // These states create the sacred breathing and shimmer effects
    
    /// Controls the outer ethereal glow animation
    @State private var isGlowing = false
    
    /// Controls the text scale animation for breathing effect
    @State private var textScale = false
    
    /// Controls the shimmer effect for divine energy flow
    @State private var shimmer = false
    
    var body: some View {
        ZStack {
            // MARK: - Outer Ethereal Circle Glow
            // This represents the divine energy field surrounding the 123 button
            // It breathes and pulses like the rhythm of consciousness itself
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.transformationOrange.opacity(isGlowing ? 0.4 : 0.2),
                            Color.transformationOrange.opacity(0.0)
                        ]),
                        center: .center,
                        startRadius: 5,
                        endRadius: isGlowing ? 42 : 32
                    )
                )
                .frame(width: size, height: size)
                .scaleEffect(isGlowing ? 1.0 : 0.88)  // Sacred breathing scale range
            
            // MARK: - Inner Glowing Circle
            // This represents the sacred space within the 123 button
            // It's the inner sanctum where divine love is downloaded
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.transformationOrange.opacity(0.3),
                            Color.transformationOrange.opacity(0.15),
                            .clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 70
                    )
                )
                .frame(width: size - 10, height: size - 10)
                .scaleEffect(isGlowing ? 0.92 : 1.08)  // Sacred breathing scale range
                .blur(radius: 2.5)
            
            // MARK: - Sacred 123 Text
            // The mantra that activates love download from the cosmos
            // It shimmers with divine energy and represents the activation phrase
            Text("123")
                .font(.system(size: size * 0.48, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color.transformationOrange,
                            Color.transformationOrange.opacity(0.8),
                            Color.transformationOrange
                        ],
                        startPoint: shimmer ? .topLeading : .bottomTrailing,
                        endPoint: shimmer ? .bottomTrailing : .topLeading
                    )
                )
                .shadow(color: Color.transformationOrange.opacity(0.6), radius: 1, x: 0, y: 1)
                .scaleEffect(textScale ? 1.10 : 1.00)  // Sacred breathing scale range
                .opacity(textScale ? 1 : 0.80)
        }
        .frame(width: size - 5, height: size - 5)
        .onAppear {
            // MARK: - Sacred Animation Setup
            // These animations represent the living, breathing nature of divine consciousness
            
            // Gentle breathing animation - represents the rhythm of consciousness
            withAnimation(
                .easeInOut(duration: 3.0)
                .repeatForever(autoreverses: true)
            ) {
                isGlowing.toggle()
                textScale.toggle()
            }
            
            // Shimmer effect - represents the flowing nature of divine energy
            withAnimation(
                .easeInOut(duration: 3.0)
                .repeatForever(autoreverses: true)
            ) {
                shimmer.toggle()
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
// Shows the HolyNumberView in action with the sacred background
#Preview {
    HolyNumberView(size: 65)
        .padding(20)
        .background(
            Image("KrishnaBG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
}
