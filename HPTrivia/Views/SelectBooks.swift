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

    private var store = Store()

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
                            if book.status == .active (book.status == .locked &&
                                                       store.purchasedProducts.contains(book.id)) {
                                ActiveBook(book: book)
                                    .task {
                                        game.bookQuestions.changeStatus(of: book.id, to: .active)
                                    }
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
                                        //4-rol indulnak a megvasarolhato konyvek,
                                        //de az a tombben 0 indexrol indul ezert von ki 4-et
                                        //ideiglenes megoldas csak
                                        let product = store.products[book.id-4]

                                        Task {
                                            await store.purchase(product)
                                        }
                                    }
                            }
                        }
                    }
                    .padding()
                }
                .interactiveDismissDisabled()
                .task {
                   await store.loadProducts()
                }


                if !activeBooks {
                    Text("You must select at least 1 book.")
                        .multilineTextAlignment(.center)
                }

                Button("Done") {
                    game.bookQuestions.saveStatus()
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
    }
}

#Preview {
    SelectBooks()
        .environment(Game())
}
