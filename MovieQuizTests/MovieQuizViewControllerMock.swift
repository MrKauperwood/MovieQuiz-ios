//
//  MovieQuizViewControllerMock.swift
//  MovieQuizTests
//
//  Created by Aleksei Bondarenko on 18.4.2024.
//

import Foundation
import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz step: QuizStepViewModel) {
        
        }
        
    func show(quiz result: QuizResultsViewModel) {
        
        }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
        }
        
    func showLoadingIndicator() {
        
        }
        
    func hideLoadingIndicator() {
        
        }
        
    func showNetworkError(message: String) {
        
        }
}
