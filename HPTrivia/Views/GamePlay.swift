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
    @Namespace private var namespace

    @State private var musicPlayer: AVAudioPlayer!
    @State private var sfxPlayer: AVAudioPlayer!

    @State private var animateViewsIn = false
    @State private var revealHint = false
    @State private var revealBook = false
    @State private var tappedCorrectAnswer = false
    @State private var wrongAnswersTapped: [String] = []

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

                    VStack {
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
                        HStack {
                            VStack {
                                if animateViewsIn {
                                    Image(systemName: "questionmark.app.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100)
                                        .foregroundStyle(.cyan)
                                        .padding()
                                        .transition(.offset(x: -geo.size.width/2))
                                        .phaseAnimator([false, true]) { content, phase in
                                            content.rotationEffect(.degrees(phase ? -13 : -17))
                                        } animation: { _ in
                                                .easeInOut(duration: 0.7)
                                        }
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: 1)) {
                                                revealHint = true
                                            }

                                            playFlipSound()
                                            game.questionScore -= 1
                                        }
                                        .rotation3DEffect(.degrees(revealHint ? 1440 :0),
                                                          axis: (x: 0, y: 1, z: 0))
                                        .scaleEffect(revealHint ? 5 : 1)
                                        .offset(x: revealHint ? geo.size.width/2.5 : 0)
                                        .opacity(revealHint ? 0 : 1)
                                        .overlay {
                                            Text(game.currentQuestion.hint)
                                                .padding(.leading, 20)
                                                .minimumScaleFactor(0.5)
                                                .multilineTextAlignment(.center)
                                                .opacity(revealHint ? 1 : 0)
                                                .scaleEffect(revealHint ? 1.33 : 1)
                                        }
                                }
                            }
                            .animation(.easeInOut(duration: 1.5).delay(2), value: animateViewsIn)

                            Spacer()

                            VStack {
                                if animateViewsIn {
                                    Image(systemName: "app.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100)
                                        .foregroundStyle(.cyan)
                                        .overlay {
                                            Image(systemName: "book.closed")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50)
                                                .foregroundStyle(.black)
                                        }
                                        .padding()
                                        .transition(.offset(x: geo.size.width/2))
                                        .phaseAnimator([false, true]) { content, phase in
                                            content.rotationEffect(.degrees(phase ? 13 : 17))
                                        } animation: { _ in
                                                .easeInOut(duration: 0.7)
                                        }
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: 1)) {
                                                revealBook = true
                                            }

                                            playFlipSound()
                                            game.questionScore -= 1
                                        }
                                        .rotation3DEffect(.degrees(revealBook ? -1440 :0),
                                                          axis: (x: 0, y: 1, z: 0))
                                        .scaleEffect(revealBook ? 5 : 1)
                                        .offset(x: revealBook ? geo.size.width/2.5 : 0)
                                        .opacity(revealBook ? 0 : 1)
                                        .overlay {
                                            Image("hp\(game.currentQuestion.book)")
                                                .resizable()
                                                .scaledToFit()
                                            // .padding(.trailing, 20)
                                                .frame(width: 100)
                                                .opacity(revealBook ? 1 : 0)
                                                .scaleEffect(revealBook ? 1.33 : 1)
                                        }
                                }
                            }
                            .animation(.easeInOut(duration: 1.5).delay(2), value: animateViewsIn)

                            Spacer()
                        }
                        .padding(.horizontal, 50)
                        .padding(.vertical, 50)

                        // MARK: Answers
                        LazyVGrid(columns: [GridItem(), GridItem()]){
                            ForEach(game.answers, id: \.self) { answer in
                                //correct answer button
                                if answer == game.currentQuestion.answer {
                                    VStack {
                                        if animateViewsIn {
                                            if !tappedCorrectAnswer {
                                                Button {
                                                    withAnimation(
                                                        .easeOut(duration: 1)
                                                    )
                                                    {
                                                        tappedCorrectAnswer = true
                                                    }

                                                    playCorrectSound()

                                                    game.correct()
                                                } label: {
                                                    Text(answer)
                                                        .minimumScaleFactor(0.5)
                                                        .multilineTextAlignment(.center)
                                                        .padding(10)
                                                        .frame(width: geo.size.width/2, height: 80)
                                                        .background(.green.opacity(0.5))
                                                        .clipShape(.rect(cornerRadius: 25))
                                                        .matchedGeometryEffect(id: 1, in: namespace)
                                                }
                                                .transition(
                                                    .asymmetric(
                                                        insertion: .scale,
                                                        removal:
                                                                .scale(scale: 15)
                                                                .combined(
                                                                    with: .opacity
                                                                )
                                                    )
                                                )
                                            }
                                        }
                                    }
                                    .animation(.easeOut(duration: 1).delay(1.5),
                                               value: animateViewsIn
                                    )
                                } else { //wrong answer
                                    VStack {
                                        if animateViewsIn {
                                            Button {
                                                // withAnimation(.easeIn(duration: 1)) {
                                                wrongAnswersTapped.append(answer)
                                                //  }

                                                playWrongSound()

                                                game.gameScore -= 1
                                            } label: {
                                                Text(answer)
                                                    .minimumScaleFactor(0.5)
                                                    .multilineTextAlignment(.center)
                                                    .padding(10)
                                                    .frame(width: geo.size.width/2.15,
                                                           height: 80)
                                                    .background(
                                                        wrongAnswersTapped
                                                            .contains(answer) ?
                                                            .red.opacity(0.5) :
                                                                .green.opacity(0.5)
                                                    )
                                                    .clipShape(.rect(cornerRadius: 25))
                                                    .scaleEffect(wrongAnswersTapped.contains(where: { $0 == answer }) ? 0.8 : 1)
                                            }
                                            .transition(.scale)
                                            .sensoryFeedback(
                                                .error,
                                                trigger: wrongAnswersTapped)
                                            .disabled(wrongAnswersTapped.contains(answer)) //they can't click twice
                                        }
                                    }
                                    .animation(.easeOut(duration: 1).delay(1.5),
                                               value: animateViewsIn
                                    )
                                }
                            }
                        }

                        Spacer()
                    }
                    .disabled(tappedCorrectAnswer)
                    .opacity(tappedCorrectAnswer ? 0.1 : 1)
                }
                .frame(width: geo.size.width, height:
                        geo.size.height)

                // MARK: Celebration
                VStack {
                    Spacer()

                    VStack {
                        if tappedCorrectAnswer {
                            Text("\(game.questionScore)")
                                .font(.largeTitle)
                                .padding(.top, 50)
                                .foregroundColor(.white)
                                .transition(.offset(y: -geo.size.height/2))
                        }

                    }
                    .animation(.easeOut(duration: 2).delay(1.5),
                               value: tappedCorrectAnswer)

                    Spacer()

                    VStack {
                        if tappedCorrectAnswer {
                            Text("Brilliant")
                                .font(.custom("PartyLetPlain", size: 100))
                                .transition(.scale.combined(with: .offset(y:
                                                            -geo.size.height/2)))

                        }
                    }
                    .animation(.easeOut(duration: 2).delay(1.5),
                               value: tappedCorrectAnswer)

                    Spacer()

                    if tappedCorrectAnswer {
                        Text(game.currentQuestion.answer)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                            .padding(10)
                            .frame(width: geo.size.width/2, height: 80)
                            .background(.green.opacity(0.5))
                            .clipShape(.rect(cornerRadius: 25))
                            .matchedGeometryEffect(id: 1, in: namespace)
                    }

                    Spacer()
                    Spacer()

                    VStack {
                        if tappedCorrectAnswer {
                            Button("Next Level >") {

                            }
                            .font(.largeTitle)
                            .buttonStyle(.borderedProminent)
                            .tint(.blue.opacity(0.5))
                            .transition(.offset(y: geo.size.height/2))
                        }
                    }
                    .animation(.easeOut(duration: 2.7).delay(2.7), value: tappedCorrectAnswer)

                    Spacer()
                    Spacer()
                }
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
              //  self.playMusic()
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
