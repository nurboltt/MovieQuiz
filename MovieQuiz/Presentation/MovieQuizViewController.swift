import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var answerButtons: [UIButton]!
    
    private weak var overlayView: UIView?
    
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenter?
  
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPresenter = AlertPresenter(movieVC: self)
        presenter = MovieQuizPresenter(viewController: self)
        showLoadingIndicator()
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    // MARK: - Private functions
    
    func showResult(quiz result: QuizResultsViewModel) {
        let overlayView = UIView(frame: self.view.bounds)
        overlayView.backgroundColor = UIColor.ypBackground
        self.view.addSubview(overlayView)
        self.overlayView = overlayView
        
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText) { [weak self] in
                guard let self = self else { return }
                
                self.presenter.restartGame()
                self.buttonState(isEnabled: true)
                self.overlayView?.removeFromSuperview()
            }
        alertPresenter?.showAlert(model: alertModel)
    }
    
    func showQuestion(quiz step: QuizStepViewModel) {
        clear()
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func buttonState(isEnabled: Bool) {
        answerButtons[0].isEnabled = isEnabled
        answerButtons[1].isEnabled = isEnabled
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
       }
    
    func clear() {
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(
            title: "Что-то пошло не так(",
            message: message,
            buttonText: "Попробовать еще раз") { [weak self] in
                guard let self = self else { return }
                
                self.presenter.restartGame()
            }
        alertPresenter?.showAlert(model: model)
    }
}
