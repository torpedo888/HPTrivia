//
//  Question.swift
//  HPTrivia
//
//  Created by Ferenc Batorligeti on 2026. 02. 15..
//

struct Question: Codable {
    let id: Int
    let question: String
    let answer: String
    let wrong: [String]
    let book: Int
    let hint: String
}
