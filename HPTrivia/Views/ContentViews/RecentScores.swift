//
//  RecentScores.swift
//  HPTrivia
//
//  Created by Ferenc Batorligeti on 2026. 02. 19..
//

import SwiftUI

struct RecentScores: View {
    @Binding var animateViewsIn: Bool
    @Environment(Game.self) var game

    var body: some View {
        VStack{
            if animateViewsIn {
                VStack {
                    Text("Recent Scores")
                        .font(.title2)

                    Text("\(game.recentScores[0])")
                    Text("\(game.recentScores[1])")
                    Text("\(game.recentScores[2])")
                }
                .font(.title3)
                .foregroundStyle(.white)
                .padding(.horizontal)
                .background(.black.opacity(0.7))
                .clipShape(.rect(cornerRadius: 15))
                .transition(.opacity)
            }
        }
        .animation(.linear(duration: 1).delay(2), value:
                    animateViewsIn)
    }
}

#Preview {
    RecentScores(animateViewsIn: .constant(true))
        .environment(Game())
}
