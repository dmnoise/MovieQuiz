import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - IBOutlet
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
    private var correctAnswers = 0
    
    private let presenter = MovieQuizPresenter()
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var statisticService: StatisticServiceProtocol?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewController = self
        
        statisticService = StatisticService()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        // Отключу кнопки, незачем их нажимать пока ничего нет
        setStateButtons(to: false)
        
        // Индикатор загрузки
        visibilityLoadingIndicaor(to: true)
        
        // Загружаем первый вопрос
        questionFactory?.loadData()
                
        // Зададим параметры для рамки
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        imageView.layer.borderColor = UIColor.clear.cgColor // Цвет пока не надо
    }
    
    // MARK: -QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
                
        if question.image == Data() {
            showNetworkError(message: "Не получилось загрузить изображение")
            return
        }
        
        visibilityLoadingIndicaor(to: false)
        
        // Включаем кнопки здесь, потому что если раньше - множно будет жмать без картинки
        setStateButtons(to: true)
        
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - Public methods
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }
    
    func didFatalToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: - IBAction
    @IBAction private func yesButtonClicked() {
        presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
    }
    
    
    @IBAction private func noButtonClicked() {
        presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
    }
    
    // MARK: - Private Methods
    /// Изменяем состояние индикатора загрузки
    private func visibilityLoadingIndicaor(to state: Bool) {
        activityIndicator.isHidden = !state
        state ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    /// Алерт при ошибке загрузки данных с сервера
    private func showNetworkError(message: String) {
        
        let alertModel = AlertModel(title: "Что-то пошло не так :(",
                                    message: message,
                                    buttonText: "Попробовать еще раз") { [weak self] in
            guard let self else { return }
            
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
                        
            self.questionFactory?.loadData()
        }

        AlertPresenter(from: alertModel).presentAlert(from: self)
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
            guard let self else { return }
            
            // Сбрасываем показатели
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            
            // Покажем новый вопрос
            self.questionFactory?.requestNextQuestion()
        }
        
        AlertPresenter(from: alertModel).presentAlert(from: self)
    }
    
    /// Переключает состояние кнопки "Да" и "Нет"
    private func setStateButtons(to state: Bool) {
        yesButton.isEnabled = state
        noButton.isEnabled = state
    }
    
    // FIXME: public
    /// Показываем результат в зависимости от ответа
    func showAnswerResult(isCorrect: Bool) {
        // Меняем цвет на красный или зеленый в зависимости от результата
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        if isCorrect {
            correctAnswers += 1
        }
        
        // Выключаем кнопки, чтобы не жмали лишний раз
        setStateButtons(to: false)
        
        // Показать следующий через секунду, чтобы было время насладиться результатом
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    /// Показывает следующий вопрос
    private func showNextQuestionOrResults() {
        // Ставлю прозрачный цвет рамки, иначе будет висеть с прошлого вопроса
        imageView.layer.borderColor = UIColor.clear.cgColor
        
        // Индикатор загрузки, т.к. картинка при плохом интернете может грузиться доолго
        visibilityLoadingIndicaor(to: true)
        
        // Если это был последний вопрос
        if presenter.isLastQuestion() {
            // Сначала сохраню, иначе не покажет рекорд текущий и +1 игру
            statisticService?.store(result: GameResult(correct: correctAnswers, total: presenter.questionsAmount, date: Date()))
            
            // Ставлю еще стандартные значения. Вдруг ничего не будет, ну и распаковать вроде как надо
            let countQuiz = statisticService?.gamesCount ?? 0
            let recordCorrect = statisticService?.bestGame.correct ?? 0
            let totalAccuracy = String(format: "%.2f", statisticService?.totalAccuracy ?? 0.0)
            let dateRecord = statisticService?.bestGame.date.dateTimeString ?? Date().dateTimeString
            
            let text = "Ваш результат \(correctAnswers)/\(presenter.questionsAmount)\n" +
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
    
    
    
}
