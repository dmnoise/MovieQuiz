//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Dmitriy Noise on 10.02.2025.
//

import UIKit

final class MovieQuizPresenter {
    let questionsAmount = 10
    private var currentQuestionIndex = 0
    
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    // MARK: -Public methods
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    // MARK: - IBAction
    func yesButtonClicked() {
        guard let currentQuestion else {
            return
        }
        
        viewController?.showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
    }
    
    
    func noButtonClicked() {
        guard let currentQuestion else {
            return
        }
    
        viewController?.showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
    }
}
