//
//  SelectBooks.swift
//  HPTrivia
//
//  Created by Ferenc Batorligeti on 2026. 02. 17..
//

import SwiftUI

struct SelectBooks: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(Game.self) private var game

    @State private var showTempAlert = false

    var body: some View {
        ZStack {
            Image(.parchment)
                .resizable()
                .ignoresSafeArea()
                .background(.brown)

            VStack{
                Text("Which books would you like to see questions from?")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()

                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem()]){
                        ForEach(game.bookQuestions.books) {book in
                            if book.status == .active {
                                ZStack(alignment: .bottomTrailing) {
                                    Image(book.image)
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)

                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .foregroundStyle(.green)
                                        .shadow(radius: 1)
                                        .padding(3)                                 
                                }
                                .onTapGesture {
                                    game.bookQuestions.changeStatus(of: book.id, to: .inactive)
                                }
                            } else if book.status == .inactive {
                                ZStack(alignment: .bottomTrailing) {
                                    Image(book.image)
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                        .overlay{
                                            Rectangle().opacity(0.33)
                                        }

                                    Image(systemName: "circle")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .foregroundStyle(.green.opacity(0.5))
                                        .shadow(radius: 1)
                                        .padding(3)
                                }
                                .onTapGesture {
                                    game.bookQuestions.changeStatus(of: book.id, to: .active)
                                }
                            } else {
                                ZStack {
                                    Image(book.image)
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                        .overlay{
                                            Rectangle().opacity(0.75)
                                        }

                                    Image(systemName: "lock.fill")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .shadow(color: .white, radius: 2)
                                        .padding(3)

                                }
                                .onTapGesture {
                                    showTempAlert.toggle()

                                    game.bookQuestions.changeStatus(of: book.id, to: .active)
                                }
                            }
                        }
                    }
                    .padding()
                }
                .alert("You just purchased a new book!", isPresented: $showTempAlert) {
                }


                Button("Done") {
                    dismiss()
                }
                .font(.largeTitle)
                .padding()
                .buttonStyle(.borderedProminent)
                .tint(.brown.mix(with:.black, by: 0.2))

            }
            .foregroundStyle(.black)
        }
    }
}

#Preview {
    SelectBooks()
        .environment(Game())
}
