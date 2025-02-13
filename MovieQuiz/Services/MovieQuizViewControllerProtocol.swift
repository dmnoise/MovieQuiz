//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Dmitriy Noise on 12.02.2025.
//

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    func visibilityLoadingIndicaor(isEnabled: Bool)
    func showNetworkError(message: String)
    func setStateButtons(isEnabled: Bool)
    
    func setTransarentImageBorder()
}
