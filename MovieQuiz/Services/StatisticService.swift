//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Aleksei Bondarenko on 28.2.2024.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, totalAmount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get set }
    var bestGame: GameRecord { get }
}

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date

    func isBetterThan(_ anotherRecord: GameRecord) -> Bool {
        return correct > anotherRecord.correct
    }
}
