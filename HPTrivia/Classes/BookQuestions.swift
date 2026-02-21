//
//  BookQuestions.swift
//  HPTrivia
//
//  Created by Ferenc Batorligeti on 2026. 02. 17..
//it books and questions together
import Foundation

@Observable
class BookQuestions {
    var books: [Book] = []

    let savePath = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first!.appending(path: "BookStatuses")

    init() {
        let decodedQuestions = decodedQuestions()
        let organizedQuestions = organizeQuestions(decodedQuestions)
        populateBooks(with: organizedQuestions)
    }

    private func decodedQuestions() -> [Question] {
        var decodedQuestions: [Question] = []

        if let url = Bundle.main.url(forResource: "trivia", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                decodedQuestions = try JSONDecoder().decode([Question].self, from:
                    data)
            } catch {
                print("Error decoding  JSON data: \(error)")
            }
        }

        return decodedQuestions
    }

    private func organizeQuestions(_ questions: [Question]) -> [[Question]] {
        var organizeQuestions: [[Question]] = [[], [], [], [], [], [], [], []]

        for question in questions {
            organizeQuestions[question.book].append(question)
        }

        return organizeQuestions
    }

    private func populateBooks(with questions: [[Question]]) {
        books.append(Book(id: 1, image: "hp1", questions: questions[1], status: .active))
        books.append(Book(id: 2, image: "hp2", questions: questions[2], status: .active))
        books.append(Book(id: 3, image: "hp3", questions: questions[3], status: .inactive))
        books.append(Book(id: 4, image: "hp4", questions: questions[4], status: .locked))
        books.append(Book(id: 5, image: "hp5", questions: questions[5], status: .locked))
        books.append(Book(id: 6, image: "hp6", questions: questions[6], status: .locked))
        books.append(Book(id: 7, image: "hp7", questions: questions[7], status: .locked))
    }

    func changeStatus(of id: Int, to status: BookStatus) {
        books[id-1].status = status
    }

    func saveStatus() {
        do {
            let jsonData = try JSONEncoder().encode(books)
            try jsonData.write(to: savePath)
        } catch {
            print("Failed to save scores: \(error)")
        }
    }

    func loadStatus() {
        do {
            let jsonData = try Data(contentsOf: savePath)
            books = try JSONDecoder().decode([Book].self, from: jsonData)
        } catch {
            let decodedQuestions = decodedQuestions()
            let organizedQuestions = organizeQuestions(decodedQuestions)
            populateBooks(with: organizedQuestions)
        }
    }
}

