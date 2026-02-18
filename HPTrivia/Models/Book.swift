//
//  Book.swift
//  HPTrivia
//
//  Created by Ferenc Batorligeti on 2026. 02. 17..
//

struct Book: Identifiable {
    let id: Int
    let image: String
    let questions: [Question]
    var status: BookStatus

    enum BookStatus {
        case active, inactive, locked
    }
}
