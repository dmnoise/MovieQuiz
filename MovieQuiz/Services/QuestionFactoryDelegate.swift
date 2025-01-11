//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Dmitriy Noise on 10.01.2025.
//

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
