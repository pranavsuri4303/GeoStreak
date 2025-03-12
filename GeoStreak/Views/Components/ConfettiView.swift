//
//  ConfettiView.swift
//  GeoStreak
//
//  Created by Pranav Suri
//

import SwiftUI

// A modifier for showing confetti
struct ConfettiModifier: ViewModifier {
    @Binding var isShowing: Bool
    let particleCount: Int
    let openingAngle: Angle
    let closingAngle: Angle
    let radius: CGFloat
    
    @State private var finishedAnimating = false
    
    func body(content: Content) -> some View {
        content
            .overlay(
                ZStack {
                    if isShowing && !finishedAnimating {
                        ConfettiContainer(
                            particleCount: particleCount,
                            openingAngle: openingAngle,
                            closingAngle: closingAngle,
                            radius: radius
                        )
                        .onAppear {
                            // Reset state
                            finishedAnimating = false
                            
                            // Stop showing confetti after 3 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    finishedAnimating = true
                                    isShowing = false
                                }
                            }
                        }
                    }
                }
            )
    }
}

struct ConfettiContainer: View {
    let particleCount: Int
    let openingAngle: Angle
    let closingAngle: Angle
    let radius: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<particleCount, id: \.self) { i in
                ConfettiParticle(
                    size: geometry.size,
                    openingAngle: openingAngle,
                    closingAngle: closingAngle,
                    radius: radius
                )
            }
        }
    }
}

struct ConfettiParticle: View {
    @State private var positionX: CGFloat = 0
    @State private var positionY: CGFloat = 0
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 0.1
    @State private var color = Color.random
    
    let size: CGSize
    let openingAngle: Angle
    let closingAngle: Angle
    let radius: CGFloat
    
    private let shapes = ["circle", "triangle", "square"]
    @State private var shape: String
    
    init(size: CGSize, openingAngle: Angle, closingAngle: Angle, radius: CGFloat) {
        self.size = size
        self.openingAngle = openingAngle
        self.closingAngle = closingAngle
        self.radius = radius
        self._shape = State(initialValue: shapes.randomElement() ?? "circle")
    }
    
    var body: some View {
        // Random shape to show
        Group {
            if shape == "circle" {
                Circle()
                    .fill(color)
            } else if shape == "triangle" {
                Triangle()
                    .fill(color)
            } else {
                Rectangle()
                    .fill(color)
            }
        }
        .frame(width: 10, height: 10)
        .position(
            x: positionX,
            y: positionY
        )
        .rotationEffect(Angle(degrees: rotation))
        .scaleEffect(scale)
        .opacity(scale)
        .onAppear {
            // Initial position from the center bottom
            let startX = size.width / 2
            let startY = size.height
            
            // Calculate random angle between opening and closing
            let angleDiff = (closingAngle.degrees - openingAngle.degrees).truncatingRemainder(dividingBy: 360)
            // Ensure we have a positive angle difference to avoid empty range error
            let safeAngleDiff = max(1.0, angleDiff) // Ensure at least 1 degree difference
            let randomAngle = openingAngle.degrees + Double.random(in: 0..<safeAngleDiff)
            
            // Calculate target position
            let distance = radius * CGFloat.random(in: 0.5...1.0)
            let targetX = startX + distance * CGFloat(cos(randomAngle * .pi / 180))
            let targetY = startY - distance * CGFloat(sin(randomAngle * .pi / 180))
            
            // Initial settings
            positionX = startX
            positionY = startY
            rotation = 0
            scale = 0.1
            
            // Animation to target position
            withAnimation(Animation.timingCurve(0.42, 0, 0.58, 1, duration: 2.0)) {
                positionX = targetX
                positionY = targetY
                rotation = Double.random(in: 180...540)
                scale = CGFloat.random(in: 0.5...1)
            }
        }
    }
}

// Triangle shape for more variety in confetti
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}

// Add random color generation
extension Color {
    static var random: Color {
        let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink]
        return colors.randomElement() ?? .blue
    }
}

// View extension for easier use
extension View {
    func confettiCannon(
        isShowing: Binding<Bool>,
        particleCount: Int = 100,
        openingAngle: Angle = Angle(degrees: 60),
        closingAngle: Angle = Angle(degrees: 120),
        radius: CGFloat = 300
    ) -> some View {
        self.modifier(
            ConfettiModifier(
                isShowing: isShowing,
                particleCount: particleCount,
                openingAngle: openingAngle,
                closingAngle: closingAngle,
                radius: radius
            )
        )
    }
}

// Preview to test the confetti view
struct ConfettiView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Tap to celebrate!")
                    .foregroundColor(.white)
                    .font(.title)
            }
        }
        .confettiCannon(isShowing: .constant(true))
    }
}