//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Aleksei Bondarenko on 28.2.2024.
//

import Foundation

final class StatisticServiceImplementation: StatisticService {
    private let userDefaults = UserDefaults.standard

    func store(correct count: Int, totalAmount: Int) {
        let newRecord = GameRecord(correct: count, total: totalAmount, date: Date())
        let currentBest = bestGame

        if newRecord.isBetterThan(currentBest) {
            bestGame = newRecord
        }

        var totalCorrect = userDefaults.integer(forKey: Keys.correct.rawValue)
        var totalQuestions = userDefaults.integer(forKey: Keys.total.rawValue)

        totalCorrect += count
        totalQuestions += totalAmount

        let currentGamesCount = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        userDefaults.set(currentGamesCount + 1, forKey: Keys.gamesCount.rawValue)

        userDefaults.set(totalCorrect, forKey: Keys.correct.rawValue)
        userDefaults.set(totalQuestions, forKey: Keys.total.rawValue)
    }

    var totalAccuracy: Double {
        let correct = userDefaults.integer(forKey: Keys.correct.rawValue)
        let total = userDefaults.integer(forKey: Keys.total.rawValue)
        return total > 0 ? 100.0 * Double(correct) / Double(total) : 0
    }

    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }

        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }

    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data)
            else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }

        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }

    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
}
