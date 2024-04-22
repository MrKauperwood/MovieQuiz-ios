//
//  MovieQuizViewControllerMock.swift
//  MovieQuizTests
//
//  Created by Aleksei Bondarenko on 18.4.2024.
//

import Foundation
@testable import MovieQuiz
import XCTest

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz _: QuizStepViewModel) {}

    func show(quiz _: QuizResultsViewModel) {}

    func highlightImageBorder(isCorrectAnswer _: Bool) {}

    func showLoadingIndicator() {}

    func hideLoadingIndicator() {}

    func showNetworkError(message _: String) {}
}
