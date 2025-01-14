//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Dmitriy Noise on 13.01.2025.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(result: GameResult)
}
