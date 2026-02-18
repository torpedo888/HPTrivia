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

    var activeBooks: Bool {
        for book in game.bookQuestions.books {
            if book.status == .active {
                return true
            }
        }

        return false
    }

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
                                ActiveBook(book: book)
                                .onTapGesture {
                                    game.bookQuestions.changeStatus(of: book.id, to: .inactive)
                                }
                            } else if book.status == .inactive {
                                InactiveBook(book: book)
                                .onTapGesture {
                                    game.bookQuestions.changeStatus(of: book.id, to: .active)
                                }
                            } else {
                                LockedBook(book: book)
                                .onTapGesture {
                                    showTempAlert.toggle()

                                    game.bookQuestions.changeStatus(of: book.id, to: .active)
                                }
                            }
                        }
                    }
                    .padding()
                }
                .interactiveDismissDisabled()
                .alert("You just purchased a new book!", isPresented: $showTempAlert) {
                }

                if !activeBooks {
                    Text("You must select at least 1 book.")
                        .multilineTextAlignment(.center)
                }

                Button("Done") {
                    dismiss()
                }
                .font(.largeTitle)
                .padding()
                .buttonStyle(.borderedProminent)
                .tint(.brown.mix(with:.black, by: 0.2))
                .disabled(!activeBooks)
            }
            .foregroundStyle(.black)
        }
        .interactiveDismissDisabled(!activeBooks)
    }
}

#Preview {
    SelectBooks()
        .environment(Game())
}
