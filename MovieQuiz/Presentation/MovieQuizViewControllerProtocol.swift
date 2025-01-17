//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Aleksei Bondarenko on 18.4.2024.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: AlertModel)

    func highlightImageBorder(isCorrectAnswer: Bool)

    func showLoadingIndicator()
    func hideLoadingIndicator()

    func showNetworkError(message: String)
}
