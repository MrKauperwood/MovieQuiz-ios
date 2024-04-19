//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Aleksei Bondarenko on 18.4.2024.
//

@testable import MovieQuiz
import XCTest

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz _: QuizStepViewModel) {}

    func show(quiz _: AlertModel) {}

    func highlightImageBorder(isCorrectAnswer _: Bool) {}

    func showLoadingIndicator() {}

    func hideLoadingIndicator() {}

    func showNetworkError(message _: String) {}
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)

        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)

        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
