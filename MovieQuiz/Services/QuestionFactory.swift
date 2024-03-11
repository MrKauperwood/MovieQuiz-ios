//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Aleksei Bondarenko on 9.2.2024.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private var remainingQuestions: [QuizQuestion]
    weak var delegate: QuestionFactoryDelegate?

    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctQuestion: true),
        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 5?", correctQuestion: true),
        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 4?", correctQuestion: true),
        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctQuestion: true),
        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 5?", correctQuestion: true),
        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 3?", correctQuestion: true),
        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctQuestion: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 5?", correctQuestion: false),
        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 7?", correctQuestion: false),
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 7?", correctQuestion: false),
    ]

    init() {
        remainingQuestions = questions
    }

    func requestNextQuestion() {
        guard !remainingQuestions.isEmpty else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }

        let index = Int(arc4random_uniform(UInt32(remainingQuestions.count)))
        let question = remainingQuestions[index]
        remainingQuestions.remove(at: index)
        delegate?.didReceiveNextQuestion(question: question)
    }

    func resetQuestions() {
        remainingQuestions = questions
    }
}
