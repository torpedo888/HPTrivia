//
//  HPTriviaApp.swift
//  HPTrivia
//
//  Created by Ferenc Batorligeti on 2026. 02. 15..
//

import SwiftUI

@main
struct HPTriviaApp: App {
    private var game = Game()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(game)
        }
    }
}
