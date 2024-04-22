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

    private let networkClient: NetworkRouting

    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }

    // MARK: - URL

    private var mostPopularMoviesUrl: URL {
        // If we cannot convert the string to a URL, the application will crash with an error
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }

    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case let .failure(error):
                handler(.failure(error))
            case let .success(data):
                do {
                    let moviesResponse = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    if let errorMessage = moviesResponse.errorMessage, !errorMessage.isEmpty {
                        // Here we create our own error with the received message to pass it to the handler
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
