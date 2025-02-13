//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Dmitriy Noise on 10.02.2025.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private let questionsAmount = 10
    private var correctAnswers = 0
    private var currentQuestionIndex = 0
    
    private let statisticService: StatisticServiceProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticService()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
    }
    
    // MARK: - Public methods
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }
    
    func didFatalToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func loadNewGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.loadData()
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func didAnswer(isYes: Bool) {
        guard let currentQuestion else {
            return
        }
        
        proceedWithAnswer(isCorrect: currentQuestion.correctAnswer == isYes)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        
        if question.image == Data() {
            viewController?.showNetworkError(message: "Не получилось загрузить изображение")
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
            self?.viewController?.setStateButtons(isEnabled: true)
            self?.viewController?.visibilityLoadingIndicaor(isEnabled: false)
        }
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                          question: model.text,
                          questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    // MARK: -Private methods
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    private func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            
            // Конец раунда, показываем алерт
            viewController?.show(quiz: QuizResultsViewModel(title: "Этот раунд окончен!",
                                                            text: makeResultMessage(),
                                                            buttonText: "Сыграть еще раз"))
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    /// Показывает результат ответа на вопрос
    private func proceedWithAnswer(isCorrect: Bool) {
        // Сразу выключаю кнопки, чтобы не жмали пока смотрят на результат
        viewController?.setStateButtons(isEnabled: false)
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        if isCorrect {
            correctAnswers += 1
        }
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            
            // Ставлю прозрачный цвет рамки, иначе будет висеть с прошлого вопроса
            self.viewController?.setTransarentImageBorder()
            
            // Индикатор загрузки, т.к. картинка при плохом интернете может грузиться доолго
            self.viewController?.visibilityLoadingIndicaor(isEnabled: true)
            
            self.proceedToNextQuestionOrResults()
        }
    }
    
    /// Генерирует сообщение с результатами
    private func makeResultMessage() -> String {
        guard let statisticService else { return "Ошибка загрузки результатов" }
        
        let gameResult = GameResult(correct: correctAnswers, total: questionsAmount, date: Date())
        statisticService.store(result: gameResult)
        
        let countQuiz = statisticService.gamesCount
        let recordCorrect = statisticService.bestGame.correct
        let totalAccuracy = String(format: "%.2f", statisticService.totalAccuracy)
        let dateRecord = statisticService.bestGame.date.dateTimeString
        
        let text = "Ваш результат \(correctAnswers)/\(questionsAmount)\n" +
        "Количество сыгранных квизов: \(countQuiz)\n" +
        "Рекорд: \(recordCorrect)/\(questionsAmount) (\(dateRecord))\n" +
        "Средняя точность: \(totalAccuracy)%"
        
        return text
    }
    
}
    
