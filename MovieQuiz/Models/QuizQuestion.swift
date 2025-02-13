//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Dmitriy Noise on 09.01.2025.
//

import Foundation

///  Создание и хранение модели, тут хранится информация о каждом вопросе
struct QuizQuestion {
    let image: Data
    let text: String
    let correctAnswer: Bool
}
