//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Nurbol on 22.06.2024.
//

import Foundation

final class StatisticServiceImplementation {
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case correct
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case gamesCount
        case total
    }
}

extension StatisticServiceImplementation: StatisticServiceProtocol {
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            if let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date {
                return GameResult(correct: correct, total: total, date: date)
            }
            return GameResult.defaultResult
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            let correct = storage.double(forKey: Keys.correct.rawValue)
            let total = storage.double(forKey: Keys.total.rawValue)
            if total != 0 {
                let result = correct/total * 100
                return result
            }
            return 0
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let newCorrect = storage.integer(forKey: Keys.correct.rawValue) + count
        let newTotal = storage.integer(forKey: Keys.total.rawValue) + amount
        storage.set(newCorrect, forKey: Keys.correct.rawValue)
        storage.set(newTotal, forKey: Keys.total.rawValue)
        
        gamesCount += 1
        
        let currentGame = GameResult(correct: count, total: amount, date: Date())
        
        if currentGame.isBetterThan(bestGame) {
                bestGame = currentGame
        }
    }
}
