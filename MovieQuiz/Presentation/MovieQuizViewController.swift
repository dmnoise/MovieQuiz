import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - IBOutlet
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    
    // MARK: - Private Properties
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(delegate: self)
        
        // Показывем первый вопрос
        questionFactory?.requestNextQuestion()
                
        // Зададим параметры для рамки
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        imageView.layer.borderColor = UIColor.clear.cgColor // Цвет пока не надо
    }
    
    // MARK: -QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    
    // MARK: - Private Methods
        
    /// Преобразуем для показа
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage.default,
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    
    /// Показать главный экран
    private func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        imageView.image = step.image
        counterLabel.text = step.questionNumber
    }
    
    
    /// Вызывает окно с результатами
    private func show(quiz step: QuizResultsViewModel) {
        let alertModel = AlertModel(title: step.title,
                               message: step.text,
                               buttonText: step.buttonText) { [weak self] in
            // Сбрасываем показатели
            self?.currentQuestionIndex = 0
            self?.correctAnswers = 0
            
            // Покажем новый вопрос
            self?.questionFactory?.requestNextQuestion()
        }
        
        AlertPresenter(from: alertModel).presentAlert(from: self)
    }
    
    /// Переключает состояние кнопки "Да" и "Нет"
    private func toggleButtonYesNo(_ state: Bool) {
        yesButton.isEnabled = state
        noButton.isEnabled = state
    }
    
    
    /// Показываем результат в зависимости от ответа
    private func showAnswerResult(isCorrect: Bool) {
        // Меняем цвет на красный или зеленый в зависимости от результата
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        // Прибавляем если ответ правильный
        if isCorrect {
            correctAnswers += 1
        }
        
        // Выключаем кнопки, чтобы не жмали лишний раз
        toggleButtonYesNo(false)
        
        // Показать следующий через секунду
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }

    
    /// Показывает следующий вопрос
    private func showNextQuestionOrResults() {
        // Ставлю прозрачный цвет рамки, иначе будет висеть с прошлого вопроса
        imageView.layer.borderColor = UIColor.clear.cgColor
        
        // Включаем кнопки обратно
        toggleButtonYesNo(true)
        
        if currentQuestionIndex == questionsAmount - 1 {
            let text = correctAnswers == questionsAmount ?
            "Поздравляем, вы ответили на \(correctAnswers) из \(questionsAmount)!" :
            "Вы ответили на \(correctAnswers) из \(questionsAmount), попробуйте еще раз!"
            
            // Конец раунда, показываем алерт
            show(quiz: QuizResultsViewModel(title: "Этот раунд окончен!",
                                            text: text,
                                            buttonText: "Сыграть еще раз"))
        } else {
            currentQuestionIndex += 1
            
            // Следующий вопрос
            questionFactory?.requestNextQuestion()
        }
    }
    
    
    
    // MARK: - IBAction
    @IBAction private func yesButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
    }
    
    
    @IBAction private func noButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
    
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
    }
    
}
