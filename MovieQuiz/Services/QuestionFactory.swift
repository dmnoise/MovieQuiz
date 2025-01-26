//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Dmitriy Noise on 09.01.2025.
//

import UIKit

final class QuestionFactory: QuestionFactoryProtocol {
    private weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []
    
/*    private let questions = [QuizQuestion(image: "The Godfather",
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
*/
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFatalToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            guard let index = (0..<movies.count).randomElement() else {
                delegate?.didReceiveNextQuestion(question: nil)
                return
            }
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            // TODO: Тут хотелось бы какой-нибудь таймаут, без интернета будет вечная загрузка( Так понимаю что в следующем уроке пояснят другой способ, поэтому делать с этим ничго не буду
            do {
                imageData = try Data(contentsOf: movie.resizedImageUrl)
            } catch {
                print("Error load image")
            }
            
            let randomNumber = Int.random(in: 5...9)
            let correctAnswer = Float(movie.rating) ?? 0 > Float(randomNumber)
            let text = "Рейтинг этого фильма больше \(randomNumber)?"
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
            
        }
    }
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate? = nil) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
}
