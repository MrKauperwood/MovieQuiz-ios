import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
//    private var correctAnswers = 0

    private let presenter = MovieQuizPresenter()
    private var statisticService: StatisticService?

//    private var questionFactory: QuestionFactoryProtocol?

    private let alertPresenter = AlertPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupQuiz()
        initialStateForTheElements()
    }

    private func setupQuiz() {
        presenter.viewController = self
        imageView.layer.cornerRadius = 20
        presenter.questionFactory = QuestionFactory(moviesLoader : MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        showLoadingIndicator()
        presenter.questionFactory?.loadData()
    }
    
    private func initialStateForTheElements() {
        // Настройка индикатора загрузки
        activityIndicator.hidesWhenStopped = true
        
        // Установка прозрачного фона для imageView
        imageView.backgroundColor = UIColor.clear
        
        // Очищаем текст в label
        textLabel.text = ""
        counterLabel.text = ""
    }

    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }

    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private var imageView: UIImageView!

    @IBOutlet private var counterLabel: UILabel!

    @IBOutlet private var textLabel: UILabel!

    @IBOutlet private var noButton: UIButton!

    @IBOutlet private var yesButton: UIButton!

    @IBAction private func noButtonClicked(_: UIButton) {
        setButtonsEnabled(false)
        presenter.noButtonClicked()
    }

    @IBAction private func yesButtonClicked(_: UIButton) {
        setButtonsEnabled(false)
        presenter.yesButtonClicked()
    }

    func setButtonsEnabled(_ isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }

    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.text
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        counterLabel.text = step.questionNumber
    }

    func changeImageState(isEnabled: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = isEnabled ? 8 : 0
        imageView.layer.cornerRadius = isEnabled ? 6 : 0
        imageView.layer.cornerRadius = 20
    }

    func showLoadingIndicator() {
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating() // включаем анимацию
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
        
        let errorModel = AlertModel(title: "Что-то пошло не так(", message: message, buttonText: "Попробовать ещё раз") {
            [weak self] in
                    guard let self = self else { return }
            self.presenter.resetQuestionIndex()
            presenter.correctAnswers = 0
            showLoadingIndicator()
            presenter.questionFactory?.loadData()
            presenter.questionFactory?.requestNextQuestion()
        }
        alertPresenter.present(alertModel: errorModel, on: self, withId: "Error alert")
    }
    
    func showAnswerResult(isCorrect: Bool) {
        changeImageState(isEnabled: true)
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        if isCorrect {
            presenter.correctAnswers += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }

    func showQuizResults() {
        // Обновляем статистику
        guard var statisticService = statisticService else { return }
        statisticService.store(correct: presenter.correctAnswers, totalAmount: presenter.questionsAmount)

        let bestGame = statisticService.bestGame
        let gamesCount = statisticService.gamesCount + 1
        let totalAccuracy = statisticService.totalAccuracy * 100

        // Формируем сообщение
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        let dateStr = dateFormatter.string(from: bestGame.date)
        let message = """
        Ваш результат: \(presenter.correctAnswers)/\(presenter.questionsAmount)
        Количество сыгранных квизов: \(gamesCount)
        Рекорд: \(bestGame.correct)/\(bestGame.total) (\(dateStr))
        Средняя точность: \(String(format: "%.2f", totalAccuracy))
        """

        // Создаем AlertModel и показываем алерт
        let model = AlertModel(
            title: "Этот раунд окончен!",
            message: message,
            buttonText: "Сыграть еще раз") {
                self.resetQuiz()
            }
        
        alertPresenter.present(alertModel: model, on: self, withId: "Game results")

        // Увеличиваем счетчик игр
        statisticService.gamesCount = gamesCount
    }

    private func resetQuiz() {
        presenter.correctAnswers = 0
        presenter.resetQuestionIndex()
        presenter.questionFactory?.requestNextQuestion()
        changeImageState(isEnabled: false)
    }

    private func showNextQuestionOrResults() {
        showLoadingIndicator()
        if presenter.isLastQuestion() {
            showQuizResults()
        } else {
            presenter.switchToNextQuestion()
            changeImageState(isEnabled: false)

            presenter.questionFactory?.requestNextQuestion()
        }
        setButtonsEnabled(true)
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator() // скрываем индикатор загрузки
        presenter.questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        hideLoadingIndicator()
        print("Ошибка загрузки данных: \(error.localizedDescription)") //Логирую
        showNetworkError(message: "Невозможно загрузить данные")
    }
}
