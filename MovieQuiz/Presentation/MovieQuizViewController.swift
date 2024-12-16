import UIKit


final class MovieQuizViewController: UIViewController {
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var counterLabel: UILabel!
    
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
    
    // Вопрос
    private struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }

    // Вопрос показан
    private struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }

    // Результат квиза
    private struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    // MARK: - Methods
    
    // Преобразуем для показа
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage.default,
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }
    
    
    // Показать главный экран
    private func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        imageView.image = step.image
        counterLabel.text = step.questionNumber
    }
    
    
    // Показать результаты
    private func show(quiz step: QuizResultsViewModel) {
        // Создаём объекты всплывающего окна
        let alert = UIAlertController(title: step.title, // заголовок всплывающего окна
                                      message: step.text, // текст во всплывающем окне
                                      preferredStyle: .alert)
        
        // Создаём для алерта кнопку с действием
        let action = UIAlertAction(title: step.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let currentQuestion = self.questions[self.currentQuestionIndex]
            self.show(quiz: self.convert(model: currentQuestion))
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        // Прибавляем если ответ правильный
        if isCorrect {
            correctAnswers += 1
        }
        
        // Показать следующий через секунду
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
           self.showNextQuestionOrResults()
        }
    }
    
    
    // Следующий вопрос
    private func showNextQuestionOrResults() {
        // Ставлю прозрачный цвет рамки, иначе будет висеть с прошлого вопроса
        imageView.layer.borderColor = UIColor.clear.cgColor
        
        if currentQuestionIndex == questions.count - 1 {
            show(quiz: QuizResultsViewModel(title: "Этот раунд окончен!",
                                            text: "Ваш результат \(correctAnswers)/\(questions.count)",
                                            buttonText: "Сыграть еще раз"))
        } else {
            currentQuestionIndex += 1
            
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
    
    
    
    // MARK: - Buttons yes and no
    @IBAction private func yesButtonClicked() {
        let currentQuestion = questions[currentQuestionIndex]
        
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
    }
    
    @IBAction private func noButtonClicked() {
        let currentQuestion = questions[currentQuestionIndex]
        
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
    }
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentQuestion = questions[currentQuestionIndex]
        show(quiz: convert(model: currentQuestion))

    }
}


/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
*/
