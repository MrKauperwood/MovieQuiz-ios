//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Aleksei Bondarenko on 21.2.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
