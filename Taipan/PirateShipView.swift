//
//  PirateShipView.swift
//  Taipan
//
//  Created by Jeff Milner on 2025-03-22.
//

import SwiftUI

struct PirateShipView: View {
    var body: some View {
        Canvas { context, size in
            let shipColor = Color.green
            var path = Path()
            
            // Ship hull
            path.move(to: CGPoint(x: 20, y: 80))
            path.addLine(to: CGPoint(x: 100, y: 100))
            path.addLine(to: CGPoint(x: 180, y: 80))
            path.addLine(to: CGPoint(x: 150, y: 60))
            path.addLine(to: CGPoint(x: 50, y: 60))
            path.closeSubpath()
            
            context.stroke(path, with: .color(shipColor), lineWidth: 2)
            
            // Deck details
            for i in stride(from: 40, to: 160, by: 20) {
                context.stroke(Path { path in
                    path.move(to: CGPoint(x: i, y: 80))
                    path.addLine(to: CGPoint(x: i + 10, y: 90))
                }, with: .color(shipColor), lineWidth: 2)
            }
            
            // Masts
            let mastPositions = [80, 120, 160]
            for pos in mastPositions {
                context.stroke(Path { path in
                    path.move(to: CGPoint(x: pos, y: 60))
                    path.addLine(to: CGPoint(x: pos, y: 20))
                }, with: .color(shipColor), lineWidth: 2)
            }
            
            // Sails
            let sailOffsets = [(-20, -10), (0, -20), (20, -10)]
            for (dx, dy) in sailOffsets {
                let sailPath = Path { path in
                    path.move(to: CGPoint(x: 100 + dx, y: 30 + dy))
                    path.addLine(to: CGPoint(x: 80 + dx, y: 50 + dy))
                    path.addLine(to: CGPoint(x: 120 + dx, y: 50 + dy))
                    path.closeSubpath()
                }
                context.stroke(sailPath, with: .color(shipColor), lineWidth: 2)
            }
            
            // Water waves
            for i in stride(from: 10, to: 200, by: 30) {
                context.stroke(Path { path in
                    path.move(to: CGPoint(x: i, y: 105))
                    path.addQuadCurve(to: CGPoint(x: i + 15, y: 100), control: CGPoint(x: i + 7, y: 110))
                }, with: .color(shipColor), lineWidth: 2)
            }
        }
        .frame(width: 200, height: 120)
        .background(Color.black)
    }
}

#Preview {
    PirateShipView()
}
