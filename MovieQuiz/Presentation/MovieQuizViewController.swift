import UIKit


final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    // MARK: - IBOutlet
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties    
    private var presenter: MovieQuizPresenter!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
            
        presenter = MovieQuizPresenter(viewController: self)
        
        visibilityLoadingIndicaor(to: true)
        setStateButtons(to: false)
                        
        // Зададим параметры для рамки
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        imageView.layer.borderColor = UIColor.clear.cgColor // Цвет пока не надо
    }
    
    // MARK: - Public Methods
    /// Изменяет состояние индикатора загрузки
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
            
            self.presenter.loadNewGame()
        }

        AlertPresenter(from: alertModel).presentAlert(from: self)
    }
    
    /// Показать главный экран
    func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        imageView.image = step.image
        counterLabel.text = step.questionNumber
    }
    
    /// Вызывает окно с результатами
    func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(title: result.title,
                                    message: result.text,
                                    buttonText: result.buttonText) { [weak self] in
            guard let self else { return }
            
            self.presenter.restartGame()
        }
        
        AlertPresenter(from: alertModel).presentAlert(from: self)
    }
    
    /// Переключает состояние кнопки "Да" и "Нет"
    func setStateButtons(to state: Bool) {
        yesButton.isEnabled = state
        noButton.isEnabled = state
    }
    
    /// Подсветить рамку изображения
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    /// Делает рамку прозрачной
    func setTransarentImageBorder() {
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    // MARK: - IBAction
    @IBAction private func yesButtonClicked() {
        presenter.didAnswer(isYes: true)
    }
    
    
    @IBAction private func noButtonClicked() {
        presenter.didAnswer(isYes: false)
    }
}



