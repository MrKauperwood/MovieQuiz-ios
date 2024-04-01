//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Aleksei Bondarenko on 22.3.2024.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    // MARK: - NetworkClient
    private let networkClient = NetworkClient()
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
            // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
            guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
                preconditionFailure("Unable to construct mostPopularMoviesUrl")
            }
            return url
        }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let data):
                do {
                    let moviesResponse = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    if let errorMessage = moviesResponse.errorMessage, !errorMessage.isEmpty {
                        // Здесь создаем свою ошибку с полученным сообщением, чтобы передать ее в handler
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        handler(.failure(error))
                    } else {
                        handler(.success(moviesResponse))
                    }
                } catch {
                    handler(.failure(error))
                }
            }
            
        }
    }
}
