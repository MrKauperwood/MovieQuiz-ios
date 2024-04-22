//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Aleksei Bondarenko on 22.3.2024.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

struct NetworkClient: NetworkRouting {
    private enum NetworkError: Error {
        case codeError
    }

    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check if an error occurred
            if let error = error {
                handler(.failure(error))
                return
            }

            // Check that we received a successful status code
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300
            {
                handler(.failure(NetworkError.codeError))
                return
            }

            // Return the data
            guard let data = data else { return }
            handler(.success(data))
        }

        task.resume()
    }
}
