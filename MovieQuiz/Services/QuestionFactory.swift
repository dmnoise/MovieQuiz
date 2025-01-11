//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Dmitriy Noise on 09.01.2025.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    weak var delegate: QuestionFactoryDelegate?
    
    private let questions = [QuizQuestion(image: "The Godfather",
                                          text: "Рейтинг этого фильма больше чем 9?",
                                          correctAnswer: true),
                             QuizQuestion(image: "The Dark Knight",
                                          text: "Рейтинг этого фильма больше чем 7?",
                                          correctAnswer: true),
                             QuizQuestion(image: "Kill Bill",
                                          text: "Рейтинг этого фильма больше чем 8?",
                                          correctAnswer: true),
                             QuizQuestion(image: "The Avengers",
                                          text: "Рейтинг этого фильма больше чем 6?",
                                          correctAnswer: true),
                             QuizQuestion(image: "Deadpool",
                                          text: "Рейтинг этого фильма больше чем 7?",
                                          correctAnswer: true),
                             QuizQuestion(image: "The Green Knight",
                                          text: "Рейтинг этого фильма больше чем 6?",
                                          correctAnswer: true),
                             QuizQuestion(image: "Old",
                                          text: "Рейтинг этого фильма больше чем 7?",
                                          correctAnswer: false),
                             QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                                          text: "Рейтинг этого фильма больше чем 5?",
                                          correctAnswer: false),
                             QuizQuestion(image: "Tesla",
                                          text: "Рейтинг этого фильма больше чем 6?",
                                          correctAnswer: false),
                             QuizQuestion(image: "Vivarium",
                                          text: "Рейтинг этого фильма больше чем 7?",
                                          correctAnswer: false)]
    
    
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        
        delegate?.didReceiveNextQuestion(question: questions[safe: index])
    }
    
    init(delegate: QuestionFactoryDelegate? = nil) {
        self.delegate = delegate
    }
}
