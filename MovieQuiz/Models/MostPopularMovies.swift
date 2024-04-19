//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Aleksei Bondarenko on 22.3.2024.
//

import Foundation

struct MostPopularMovies: Codable {
    let errorMessage: String?
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL

    var resizeImageURL: URL {
        let urlString = imageURL.absoluteString
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"

        guard let newUrl = URL(string: imageUrlString) else {
            return imageURL
        }

        return newUrl
    }

    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
