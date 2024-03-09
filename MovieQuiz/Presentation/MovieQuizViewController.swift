import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    private var currentQuestionIndex = 0
    private var correctAnswers = 0

    private var statisticService: StatisticService?

    private var questionsAmount = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?

    private let alertPresenter = AlertPresenter()

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            text: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupQuiz()
    }

    private func setupQuiz() {
        questionFactory = QuestionFactory()
        statisticService = StatisticServiceImplementation()
        questionFactory?.delegate = self
        questionFactory?.requestNextQuestion()
    }

    // MARK: - QuestionFactoryDelegate

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

    @IBOutlet private var imageView: UIImageView!

    @IBOutlet private var counterLabel: UILabel!

    @IBOutlet private var textLabel: UILabel!

    @IBOutlet private var noButton: UIButton!

    @IBOutlet private var yesButton: UIButton!

    @IBAction private func noButtonClicked(_: UIButton) {
        setButtonsEnabled(false)
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: currentQuestion.correctQuestion == false)
    }

    @IBAction private func yesButtonClicked(_: UIButton) {
        setButtonsEnabled(false)
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: currentQuestion.correctQuestion == true)
    }

    private func setButtonsEnabled(_ isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }

    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.text
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        counterLabel.text = step.questionNumber
    }

    private func changeImageState(isEnabled: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = isEnabled ? 8 : 0
        imageView.layer.cornerRadius = isEnabled ? 6 : 0
    }

    private func showAnswerResult(isCorrect: Bool) {
        changeImageState(isEnabled: true)
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        if isCorrect {
            correctAnswers += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }

    private func showQuizResults() {
        // Обновляем статистику
        guard var statisticService = statisticService else { return }
        statisticService.store(correct: correctAnswers, totalAmount: questionsAmount)

        let bestGame = statisticService.bestGame
        let gamesCount = statisticService.gamesCount + 1
        let totalAccuracy = statisticService.totalAccuracy * 100

        // Формируем сообщение
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        let dateStr = dateFormatter.string(from: bestGame.date)
        let message = """
        Ваш результат: \(correctAnswers)/\(questionsAmount)
        Количество сыгранных квизов: \(gamesCount)
        Рекорд: \(bestGame.correct)/\(bestGame.total) (\(dateStr))
        Средняя точность: \(String(format: "%.2f", totalAccuracy))
        """

        // Создаем AlertModel и показываем алерт
        let model = AlertModel(title: "Этот раунд окончен!", message: message, buttonText: "Сыграть еще раз") {
            self.resetQuiz()
        }
        alertPresenter.present(alertModel: model, on: self)

        // Увеличиваем счетчик игр
        statisticService.gamesCount = gamesCount
    }

    private func resetQuiz() {
        correctAnswers = 0
        currentQuestionIndex = 0
        questionFactory?.resetQuestions()
        questionFactory?.requestNextQuestion()
        changeImageState(isEnabled: false)
    }

    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            showQuizResults()
        } else {
            currentQuestionIndex += 1
            changeImageState(isEnabled: false)

            questionFactory?.requestNextQuestion()
        }
        setButtonsEnabled(true)
    }
}
