//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Aleksei Bondarenko on 10.2.2024.
//

import Foundation

protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate? { get set }
    func requestNextQuestion()
    func resetQuestions()
}
