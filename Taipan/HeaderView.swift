//
//  HeaderView.swift
//  Taipan
//
//  Created by Jeff Milner on 2025-03-21.
//

import SwiftUI

struct HeaderView: View {
    @ObservedObject var gameState: GameState
    
    var body: some View {
        HStack {
            Text("Firm: \(gameState.firmName)")
                .fontWeight(.bold)
                .foregroundColor(.green)
            Spacer()
            Text("Taipan")
                .fontWeight(.bold)
        }
        .padding(.horizontal)
        .background(Color.black)
    }
}

//#Preview {
//    HeaderView()
//}
