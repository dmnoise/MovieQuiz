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
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate? = nil) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
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

            do {
                imageData = try Data(contentsOf: movie.resizedImageUrl)
            } catch {
                print("Error load image")
            }
            
            let randomNumber = Int.random(in: 6...9)
            let randomQuestion = Bool.random() ? "больше" : "меньше"
            let correctAnswer = randomQuestion == "больше"
                ? Float(movie.rating) ?? 0 > Float(randomNumber)
                : Float(movie.rating) ?? 0 < Float(randomNumber)
                
            let text = "Рейтинг этого фильма \(randomQuestion) чем \(randomNumber)?"
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
            
        }
    }
}
