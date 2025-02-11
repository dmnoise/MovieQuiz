import UIKit


final class MovieQuizViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties    
    private var presenter: MovieQuizPresenter!
    private var statisticService: StatisticServiceProtocol?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
            
        statisticService = StatisticService()
        presenter = MovieQuizPresenter(viewController: self)
        
        visibilityLoadingIndicaor(to: true)
        setStateButtons(to: false)
                        
        // Зададим параметры для рамки
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        imageView.layer.borderColor = UIColor.clear.cgColor // Цвет пока не надо
    }
    
    
    
    // MARK: - IBAction
    @IBAction private func yesButtonClicked() {
        presenter.yesButtonClicked()
    }
    
    
    @IBAction private func noButtonClicked() {
        presenter.noButtonClicked()
    }
    
    // MARK: - Private Methods
    /// Изменяем состояние индикатора загрузки
    func visibilityLoadingIndicaor(to state: Bool) {
        activityIndicator.isHidden = !state
        state ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    /// Алерт при ошибке загрузки данных с сервера
    func showNetworkError(message: String) {
        
        let alertModel = AlertModel(title: "Что-то пошло не так :(",
                                    message: message,
                                    buttonText: "Попробовать еще раз") { [weak self] in
            guard let self else { return }
            
            self.presenter.restartGame()
        }

        AlertPresenter(from: alertModel).presentAlert(from: self)
    }
    
//FIXME: public
    /// Показать главный экран
    func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        imageView.image = step.image
        counterLabel.text = step.questionNumber
    }
    
    /// Вызывает окно с результатами
    func show(quiz step: QuizResultsViewModel) {
        let alertModel = AlertModel(title: step.title,
                                    message: step.text,
                                    buttonText: step.buttonText) { [weak self] in
            guard let self else { return }
            
            // Сбрасываем показатели
            self.presenter.restartGame()
        }
        
        AlertPresenter(from: alertModel).presentAlert(from: self)
    }
    
    /// Переключает состояние кнопки "Да" и "Нет"
    func setStateButtons(to state: Bool) {
        yesButton.isEnabled = state
        noButton.isEnabled = state
    }
    
    func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderColor = isCorrect
            ? UIColor.ypGreen.cgColor
            : UIColor.ypRed.cgColor
        
        presenter.didAnswer(isCorrect: isCorrect)
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            
            // Ставлю прозрачный цвет рамки, иначе будет висеть с прошлого вопроса
            imageView.layer.borderColor = UIColor.clear.cgColor
            
            // Индикатор загрузки, т.к. картинка при плохом интернете может грузиться доолго
            visibilityLoadingIndicaor(to: true)
            
            setStateButtons(to: false)
            
            self.presenter.showNextQuestionOrResults()
            
        }
    }
     
    /// Показывает следующий вопрос
    /*
     private func showNextQuestionOrResults() {
        // Ставлю прозрачный цвет рамки, иначе будет висеть с прошлого вопроса
        imageView.layer.borderColor = UIColor.clear.cgColor
        
        // Индикатор загрузки, т.к. картинка при плохом интернете может грузиться доолго
        visibilityLoadingIndicaor(to: true)
        
        // Если это был последний вопрос
        if presenter.isLastQuestion() {
            // Сначала сохраню, иначе не покажет рекорд текущий и +1 игру
            statisticService?.store(result: GameResult(correct: presenter.correctAnswers, total: presenter.questionsAmount, date: Date()))
            
            // Ставлю еще стандартные значения. Вдруг ничего не будет, ну и распаковать вроде как надо
            let countQuiz = statisticService?.gamesCount ?? 0
            let recordCorrect = statisticService?.bestGame.correct ?? 0
            let totalAccuracy = String(format: "%.2f", statisticService?.totalAccuracy ?? 0.0)
            let dateRecord = statisticService?.bestGame.date.dateTimeString ?? Date().dateTimeString
            
            let text = "Ваш результат \(presenter.correctAnswers)/\(presenter.questionsAmount)\n" +
            "Количество сыгранных квизов: \(countQuiz)\n" +
            "Рекорд: \(recordCorrect)/\(presenter.questionsAmount) (\(dateRecord))\n" +
            "Средняя точность: \(totalAccuracy)%"
            
            // Конец раунда, показываем алерт
            show(quiz: QuizResultsViewModel(title: "Этот раунд окончен!",
                                            text: text,
                                            buttonText: "Сыграть еще раз"))
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
     */
    
    
    
}
