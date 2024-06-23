//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Nurbol on 22.06.2024.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    static let defaultResult = GameResult(correct: 0, total: 0, date: Date(timeIntervalSince1970: 0))
    
    func isBetterThan(_ anotherGame: GameResult) -> Bool {
        correct > anotherGame.correct
    }
}


