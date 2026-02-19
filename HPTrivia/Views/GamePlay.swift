//
//  GamePlay.swift
//  HPTrivia
//
//  Created by Ferenc Batorligeti on 2026. 02. 19..
//

import SwiftUI
import AVKit

struct GamePlay: View {
    @Environment(Game.self) private var game
    @Environment(\.dismiss) private var dismiss

    @State private var musicPlayer: AVAudioPlayer!
    @State private var sfxPlayer: AVAudioPlayer!

    @State private var animateViewsIn = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(.hogwarts)
                    .resizable()
                    .frame(width: geo.size.width * 3, height: geo.size.height * 1.05)
                    .overlay {
                        Rectangle()
                            .foregroundStyle(.black.opacity(0.8))

                    }

                VStack {
                    // MARK: Controls
                    HStack {
                        //Button
                        Button("End Game") {
                            game.endGame()
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red.opacity(0.5))

                        //Spacer
                        Spacer()

                        //Text
                        Text("Score: \(game.gameScore)")
                    }
                    .padding()
                    .padding(.vertical, 30)

                    // MARK: Question
                    VStack{
                        if animateViewsIn {
                            Text(game.currentQuestion.question)
                                .font(.custom("PartyLetPlain", size: 50))
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    }
                    .animation(.easeInOut(duration: 2), value: animateViewsIn)

                    // MARK: Hints

                    // MARK: Answers

                    Spacer()
                }
                .frame(width: geo.size.width, height:
                        geo.size.height)
               // .padding(.top : 20)

                // MARK: Celebration
            }
            .frame(width: geo.size.width, height:
                    geo.size.height)
            .foregroundStyle(.white)
        }
        .ignoresSafeArea()
        .onAppear {
            game.StartGame()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                animateViewsIn = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.playMusic()
            })
        }
    }

    private func playMusic() {
        let songs = ["let-the-mystery-unfold", "spellcraft",
                     "hiding-place-in-the-forest.mp3", "deep-in-the-dell"]

        let song = songs.randomElement()!

        let sound = Bundle.main.path(forResource: song,
                                     ofType: "mp3")
        musicPlayer = try! AVAudioPlayer(contentsOf: URL(filePath:
                                                            sound!))
        musicPlayer.numberOfLoops = -1
        musicPlayer.volume = 0.1
        musicPlayer.play()
    }

    private func playFlipSound() {
        let sound = Bundle.main.path(forResource: "page-flip", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        sfxPlayer.play()
    }

    private func playWrongSound() {
        let sound = Bundle.main.path(forResource: "negative-beeps", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        sfxPlayer.play()
    }

    private func playCorrectSound() {
        let sound = Bundle.main.path(forResource: "magic-wand", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        sfxPlayer.play()
    }
}

#Preview {
    GamePlay()
        .environment(Game())
}
