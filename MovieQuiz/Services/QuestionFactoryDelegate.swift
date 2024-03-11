//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Aleksei Bondarenko on 12.2.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
