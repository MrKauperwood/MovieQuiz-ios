//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Aleksei Bondarenko on 9.2.2024.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading

    private var averageRating: Float = 0.0
    private var standardDeviation: Float = 0.0

    internal weak var delegate: QuestionFactoryDelegate?
    internal var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
           
           do {
                imageData = try Data(contentsOf: movie.resizeImageURL)
            } catch {
                print("Failed to load image")
            }
            
            // Генерация порогового значения
            let lowerBound = self.averageRating - self.standardDeviation
            let upperBound = self.averageRating + self.standardDeviation
            let thresholdRating = Float.random(in: lowerBound...upperBound)
            
            // Определение типа вопроса (больше или меньше)
            let isQuestionForHigherRating = Bool.random()
            let questionType = isQuestionForHigherRating ? "больше" : "меньше"
            
            
            let rating = Float(movie.rating) ?? 0
            let questionText = "Рейтинг этого фильма \(questionType) чем \(String(format: "%.1f", thresholdRating))?"
                    
            let correctAnswer = rating > thresholdRating
            
            let question = QuizQuestion(image: imageData,
                                         text: questionText,
                                        correctQuestion: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }

    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.analyzeRatings()
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    private func analyzeRatings() {
        let ratings = movies.compactMap { Float($0.rating) } // Преобразование рейтингов фильмов в массив чисел
        guard !ratings.isEmpty else { return } // Проверка, что массив не пустой
        
        self.averageRating = ratings.reduce(0, +) / Float(ratings.count) // Вычисление среднего значения рейтингов
        let sumOfSquaredAvgDiff = ratings.map { pow($0 - averageRating, 2) }.reduce(0, +) // Сумма квадратов разностей рейтингов и среднего значения
        self.standardDeviation = sqrt(sumOfSquaredAvgDiff / Float(ratings.count)) // Вычисление стандартного отклонения
        
    }
}
