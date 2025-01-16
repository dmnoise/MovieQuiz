//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Dmitriy Noise on 13.01.2025.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    private enum Keys: String {
        case correct
        case gamesCount
        case bestGameCount
        case bestGameAmmout
        case bestGameDate
        
    }
    
    private let storage: UserDefaults = .standard
    
    /// Общее кол-во правильнх ответов
    var correctAnswers: Int {
        get {
            storage.integer(forKey: Keys.correct.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    /// Общее кол-во игр
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }

    /// Лучшая игра
    var bestGame: GameResult {
        get {
            GameResult(correct: storage.integer(forKey: Keys.bestGameCount.rawValue),
                       total: storage.integer(forKey: Keys.bestGameAmmout.rawValue),
                       date: storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date())
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCount.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameAmmout.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    /// Средняя точность
    var totalAccuracy: Double {
        // Исключаем деление на 0
        if correctAnswers == 0 {
            return 0.0
        }
        
        // (правильные ответы за все игры / (10 * кол-во игр)) * 100
        let accuracy: Double = Double(correctAnswers) / (10.0 * Double(gamesCount)) * 100.0
        return accuracy
    }
    
    
    /// Здесь сохраняется лучшая игра и другая статистика
    func store(result: GameResult) {
        gamesCount += 1
        correctAnswers += result.correct
                
        if result.isBetterThan(bestGame) {
            bestGame = result
        }
    }    
    
}
