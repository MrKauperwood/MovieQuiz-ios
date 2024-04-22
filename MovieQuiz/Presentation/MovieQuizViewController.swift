// Rus version
import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!

    private var presenter: MovieQuizPresenter!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = MovieQuizPresenter(viewController: self)

        imageView.layer.cornerRadius = 20
        imageView.layer.opacity = 0
        showLoadingIndicator()
    }

    // MARK: - Actions

    @IBAction private func yesButtonClicked(_: UIButton) {
        setButtonsEnabled(false)
        presenter.yesButtonClicked()
    }

    @IBAction private func noButtonClicked(_: UIButton) {
        presenter.noButtonClicked()
        setButtonsEnabled(false)
    }

    // MARK: - Private functions

    func show(quiz step: QuizStepViewModel) {
        showLoadingIndicator()
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        imageView.layer.opacity = 1
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        setButtonsEnabled(true)
        hideLoadingIndicator()
    }

    func show(quiz result: AlertModel) {
        let alertPresenter = AlertPresenter()
        alertPresenter.present(alertModel: result, on: self, withId: "Game results")
    }

    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }

    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }

    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }

    func setButtonsEnabled(_ isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }

    func showNetworkError(message: String) {
        hideLoadingIndicator()

        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз",
            completion: { [weak self] in
                self?.presenter.restartGame()
            }
        )
        let alertPresenter = AlertPresenter()
        alertPresenter.present(alertModel: alertModel, on: self, withId: "errorAlert")
    }
}
