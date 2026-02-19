//
//  ContentView.swift
//  HPTrivia
//
//  Created by Ferenc Batorligeti on 2026. 02. 15..
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State private var audioPlayer: AVAudioPlayer!
    @State private var animateViewsIn = false
    @State private var scalePlayButton = false

    @State private var showInstructions = false
    @State private var showSettings = false
    @State private var playGame = false

    var body: some View {
        GeometryReader {geo in
            ZStack {
                Image(.hogwarts)
                    .resizable()
                    .frame(width: geo.size.width * 3,
                           height: geo.size.height)
                    .padding(.top, 3)
                    .phaseAnimator([false , true]) { content, phase in
                        content
                            .offset(x: phase ? geo.size.width/1.1 :
                            -geo.size.width/1.1)
                    } animation: { _ in
                            .linear(duration: 60)
                    }

                VStack{

                    VStack{
                        if animateViewsIn {
                            VStack
                            {
                                Image(systemName: "bolt.fill")
                                    .imageScale(.large)
                                    .font(.largeTitle)

                                Text("HP")
                                    .font(.custom("PartyLetPlain", size: 70))
                                    .padding(.bottom, -50)

                                Text("Trivia")
                                    .font(.custom("PartyLetPlain", size: 60))
                            }
                            .padding(.top, 70)
                            .transition(.move(edge: .top))
                        }
                    }
                    .animation(.easeInOut(duration: 0.7).delay(2), value: animateViewsIn)

                    Spacer()

                    RecentScores(animateViewsIn: $animateViewsIn)

                    Spacer()

                    HStack {
                        Spacer()

                        VStack {
                            if animateViewsIn {
                                Button {
                                    showInstructions.toggle()
                                } label: {
                                    Image(systemName: "info.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(.white)
                                        .shadow(radius: 5)
                                }
                                .transition(.offset(x: -geo.size.width/3))
                            }
                        }
                        .animation(.easeInOut(duration: 0.7).delay(2.7), value: animateViewsIn)


                        Spacer()

                        VStack {
                            if animateViewsIn {
                                Button {
                                    playGame.toggle()
                                } label: {
                                    Text("Play")
                                        .font(.largeTitle)
                                        .foregroundStyle(.white)
                                        .padding(.vertical, 7)
                                        .padding(.horizontal, 50)
                                        .background(.brown)
                                        .clipShape(.rect(cornerRadius: 7))
                                        .shadow(radius: 5)
                                        .scaleEffect(scalePlayButton ? 1.2 : 1)
                                        .onAppear {
                                            withAnimation(.easeInOut(duration:
                                                                        1.3).repeatForever()) {
                                                scalePlayButton.toggle()
                                            }
                                        }
                                }
                                .transition(.offset(y: geo.size.height/3))
                            }
                        }
                        .animation(.easeInOut(duration: 0.7).delay(2), value: animateViewsIn)

                        Spacer()

                        VStack{
                            if animateViewsIn {
                                Button {
                                    showSettings.toggle()
                                } label: {
                                    Image(systemName: "gearshape.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(.white)
                                        .shadow(radius: 5)
                                }
                                .transition(.offset(x: geo.size.width/3))

                            }
                        }
                        .animation(.easeInOut(duration: 0.7).delay(2.7), value: animateViewsIn)
                        .sheet(isPresented: $showSettings) {
                            SelectBooks()
                        }


                        Spacer()
                    }
                    .frame(width: geo.size.width)

                    Spacer()
                }
            }
            .frame(maxWidth: geo.size.width, maxHeight: geo.size.height)
        }
        .ignoresSafeArea()
        .onAppear {
            animateViewsIn = true
          //  playAudio()
        }
        .sheet(isPresented: $showInstructions){
            Instructions()
        }
        .fullScreenCover(isPresented: $playGame) {
            GamePlay()
                .onAppear {
                    audioPlayer.setVolume(0, fadeDuration: 2)
                }
                .onDisappear {
                    audioPlayer.setVolume(1, fadeDuration: 2)
                }
        }
    }

    private func playAudio() {
        let sound = Bundle.main.path(forResource: "magic-in-the-air", ofType: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        audioPlayer.numberOfLoops = -1
        audioPlayer.play()
    }
}

#Preview {
    ContentView()
       .environment(Game())
}
