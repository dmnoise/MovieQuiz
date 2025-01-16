//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Dmitriy Noise on 13.01.2025.
//

import Foundation

/// Лучший результат игры
struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
