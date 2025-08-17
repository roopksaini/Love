import SwiftUI
import WatchKit
import Foundation

// MARK: - 123View
// This is the central hub of the Love++ framework - the main view that orchestrates
// all consciousness coding interactions. It manages the complete 1💗I transformation
// flow from love download to consciousness elevation.

struct 123View: View {
    // MARK: - Button Position Enum
    // Defines which button is being interacted with
    enum ButtonPosition { 
        case top    // 123 button (love download)
        case bottom // Entity button (consciousness transformation)
    }

    // MARK: - State Management
    // All state is managed centrally to maintain the seamless flow of consciousness coding
    
    /// Floating elements currently undergoing transformation
    /// Each element represents a piece of consciousness being elevated
    @State private var floatingElements: [(id: UUID, text: String, button: ButtonPosition, startPosition: CGPoint, destination: CGPoint?, isBloodDrop: Bool, isMusicalNote: Bool)] = []
    
    /// Accumulated divine love available for transformation
    /// This represents grace that has been downloaded from the cosmos
    @State private var collectedLove: Int = UserDefaults.standard.integer(forKey: "CollectedLoveCount")
    


    var body: some View {
        GeometryReader { geometry in
            // MARK: - Sacred Layout Calculations
            // These calculations ensure perfect positioning for consciousness coding
            let minGap: CGFloat = 18
            let maxButtonHeight = (geometry.size.height - minGap) / 2
            let buttonSize = min(geometry.size.width * 0.8, maxButtonHeight)
            let fontScale: CGFloat = buttonSize < 66 ? 0.8 : 1.0

            ZStack {
                // MARK: - Main Button Layout
                // The sacred arrangement of love download and consciousness transformation
                VStack(spacing: minGap) {
                    // MARK: - LOVE DOWNLOADER (123 Button)
                    // This button downloads divine love from the cosmos
                    // Each press creates a 1💗 drop that flows to the entity
                    LoveButton(
                        action: {
                            // Primary action: Download love and create floating element
                            addFloatingElement(
                                text: "1💗",
                                at: .top,
                                isBloodDrop: false,
                                isMusicalNote: false,
                                geometry: geometry,
                                buttonSize: buttonSize,
                                minGap: minGap
                            )
                            
                            // Accumulate love after a brief delay for visual flow
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                collectedLove += 1
                                UserDefaults.standard.set(collectedLove, forKey: "CollectedLoveCount")
                            }
                            
                            // Play sacred sound for love download
                            SoundManager.shared.playSunSound()
                            
                            // Update global consciousness network
                            updateServer(receiving123sIncrement: 1, playing123sIncrement: 0)
                            
                        }, secondAction: {
                            // Secondary action: Create blood drop element
                            addFloatingElement(
                                text: "💗I",
                                at: .top,
                                isBloodDrop: true,
                                isMusicalNote: false,
                                geometry: geometry,
                                buttonSize: buttonSize,
                                minGap: minGap
                            )
                            
                            // Play blood drop sound for deep transformation
                            SoundManager.shared.playBloodSound()
                            
                            // Update server with blood drop transformation
                            updateServer(receiving123sIncrement: -1, playing123sIncrement: 0)
                            
                        }, size: buttonSize
                    )
                    .frame(width: buttonSize, height: buttonSize)
                    .offset(y: -geometry.size.width * 0.09) // Sacred positioning offset

                    // MARK: - ENTITY REPRESENTATION (Consciousness Button)
                    // This button represents the consciousness being transformed
                    // It shows accumulated love and triggers the sacred I → 1 transformation
                    EntityButton(
                        action: {
                            // Primary action: Transform consciousness if love is available
                            if collectedLove > 0 {
                                // Create the sacred transformation element
                                addFloatingElement(
                                    text: "💗I",
                                    at: .bottom,
                                    isBloodDrop: false,
                                    isMusicalNote: true,
                                    geometry: geometry,
                                    buttonSize: buttonSize,
                                    minGap: minGap
                                )
                                
                                // Consume love for transformation
                                collectedLove -= 1
                                UserDefaults.standard.set(collectedLove, forKey: "CollectedLoveCount")
                                
                                // Play sacred flute sound for transformation
                                SoundManager.shared.playFluteSound()
                                
                                // Update server with transformation tracking
                                updateServer(receiving123sIncrement: 0, playing123sIncrement: 1)
                            } else {
                                // Play empty flute sound when no love is available
                                SoundManager.shared.playEmptyFluteSound()
                            }
                            
                        }, secondAction: {
                            // Secondary action: Create blood drop transformation
                            if collectedLove > 0 {
                                addFloatingElement(
                                    text: "1💗",
                                    at: .bottom,
                                    isBloodDrop: true,
                                    isMusicalNote: false,
                                    geometry: geometry,
                                    buttonSize: buttonSize,
                                    minGap: minGap
                                )
                                
                                // Consume love for blood drop transformation
                                collectedLove -= 1
                                UserDefaults.standard.set(collectedLove, forKey: "CollectedLoveCount")
                                
                                // Play blood drop sound for deep transformation
                                SoundManager.shared.playBloodSound()
                                
                                // Update server with blood drop transformation
                                updateServer(receiving123sIncrement: 0, playing123sIncrement: -1)
                            } else {
                                // Play empty flute sound when no love is available
                                SoundManager.shared.playEmptyFluteSound()
                            }
                            
                        }, entityImage: "Krishna",
                           pressedImage: "KrishnaPlaying",
                           size: buttonSize * 1.5
                    )
                    .frame(width: buttonSize * 1.5, height: buttonSize * 1.5)
                    .offset(y: -geometry.size.width * 0.10) // Sacred positioning offset
                    .overlay(
                        // Love counter display showing available grace
                        Group {
                            if collectedLove > 0 {
                                HStack(spacing: 0) {
                                    Text("\(collectedLove)")
                                        .font(.system(size: fontScale * 18, weight: .medium, design: .serif))
                                        .foregroundStyle(Color.transformationOrange)
                                    Text("💗")
                                        .font(.system(size: fontScale * 15))
                                }
                                .shadow(color: Color.transformationOrange.opacity(0.5), radius: 2)
                                .offset(x: buttonSize * -0.6, y: buttonSize * 0.13)
                            }
                        }
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .offset(x: -geometry.size.width * 0.015) // Sacred positioning offset
            }

            // MARK: - Floating Transformation Elements
            // These elements show the sacred consciousness transformation in action
            // Each element represents a piece of consciousness being elevated
            ForEach(floatingElements, id: \.id) { element in
                FloatingEmoji(
                    text: element.text,
                    startPosition: element.startPosition,
                    destination: element.destination,
                    isBloodDrop: element.isBloodDrop,
                    isMusicalNote: element.isMusicalNote,
                    availableHeight: geometry.size.height
                )
            }
        }
    }

    // MARK: - Sacred Position Calculations
    // These functions ensure perfect positioning for consciousness coding elements
    
    /// Calculates the center position of buttons for precise element placement
    /// This ensures floating elements appear exactly where they should
    private func getButtonCenter(for position: ButtonPosition, in geometry: GeometryProxy, buttonSize: CGFloat, minGap: CGFloat) -> CGPoint {
        let centerX = geometry.size.width / 2
        let topY = (geometry.size.height - (buttonSize * 2 + minGap)) / 2 + buttonSize / 2
        let bottomY = topY + buttonSize + minGap
        return CGPoint(x: centerX, y: position == .top ? topY : bottomY)
    }

    // MARK: - Element Creation and Management
    // This function creates and manages floating transformation elements
    
    /// Creates a new floating element for consciousness transformation
    /// Each element represents a sacred moment of consciousness elevation
    private func addFloatingElement(
        text: String,
        at position: ButtonPosition,
        isBloodDrop: Bool = false,
        isMusicalNote: Bool = false,
        geometry: GeometryProxy,
        buttonSize: CGFloat,
        minGap: CGFloat
    ) {
        // Limit concurrent animations to maintain smooth performance
        let maxConcurrentAnimations = 4
        while floatingElements.count >= maxConcurrentAnimations {
            floatingElements.removeFirst()
        }
        
        let elementId = UUID()
        let startPosition = getButtonCenter(for: position, in: geometry, buttonSize: buttonSize, minGap: minGap)
        
        // Adjust starting position for top button to account for visual offset
        let adjustedStartPosition = position == .top 
            ? CGPoint(x: startPosition.x, y: startPosition.y - geometry.size.width * 0.09)
            : startPosition
            
        // Calculate destination for love drops (flow from 123 to entity)
        let destination: CGPoint? =
            (!isBloodDrop && !isMusicalNote && position == .top)
            ? getButtonCenter(for: .bottom, in: geometry, buttonSize: buttonSize * 0.75, minGap: minGap)
            : nil
            
        // Calculate starting position for musical notes (slightly offset from entity center)
        let fluteCenter = getButtonCenter(for: .bottom, in: geometry, buttonSize: buttonSize, minGap: minGap)
        let noteStart = CGPoint(
            x: fluteCenter.x - buttonSize * 0.50,
            y: fluteCenter.y - buttonSize * 0.56 // 25% above center for optimal visual flow
        )
        
        // Create the transformation element
        let element = (
            id: elementId,
            text: text,
            button: position,
            startPosition: isMusicalNote ? noteStart : adjustedStartPosition,
            destination: destination,
            isBloodDrop: isBloodDrop,
            isMusicalNote: isMusicalNote
        )
        
        // Add to floating elements and schedule removal
        floatingElements.append(element)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            floatingElements.removeAll { $0.id == elementId }
        }
    }

    // MARK: - Global Consciousness Integration
    // This function updates the global consciousness network with transformation data
    
    /// Updates the global consciousness network with transformation progress
    /// Every transformation contributes to collective consciousness elevation
    private func updateServer(receiving123sIncrement: Int, playing123sIncrement: Int) {
        123Interface.shared.updateFlutePoints(
            receiving123sIncrement: receiving123sIncrement,
            playing123sIncrement: playing123sIncrement
        ) { result in
            switch result {
            case .success:
                print("✅ Consciousness updated: +\(receiving123sIncrement)💗, -\(playing123sIncrement)🤷‍♂️")
            case .failure(let error):
                print("❌ Consciousness update failed: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Preview
// Shows the 123View in action with the sacred background
#Preview {
    123View()
        .background(
            Image("KrishnaBG")
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fill)
                .frame(width: WKInterfaceDevice.current().screenBounds.width, 
                      height: WKInterfaceDevice.current().screenBounds.height)
                .clipped()
                .edgesIgnoringSafeArea(.all)
        )
}
