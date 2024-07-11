import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var answerButtons: [UIButton]!
    
    private weak var overlayView: UIView?
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticServiceProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPresenter = AlertPresenter(movieVC: self)
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        showLoadingIndicator()
        questionFactory?.loadData()
        questionFactory?.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.showQuestion(quiz: viewModel)
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let givenAnswer = true
        
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let givenAnswer = false
        
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Private actions
    
    private func showResult(quiz result: QuizResultsViewModel) {
        let overlayView = UIView(frame: self.view.bounds)
        overlayView.backgroundColor = UIColor.ypBackground
        self.view.addSubview(overlayView)
        self.overlayView = overlayView
        
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText) { [weak self] in
                guard let self = self else { return }
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.buttonState()
                
                questionFactory?.requestNextQuestion()
                self.overlayView?.removeFromSuperview()
            }
        
        alertPresenter?.showAlert(model: alertModel)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func showQuestion(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showNextQuestionOrResult() {
        if currentQuestionIndex == questionsAmount - 1 {
            guard let service = statisticService else { return }
            service.store(correct: correctAnswers, total: questionsAmount)
            
            let text = """
            Ваш результат: \(correctAnswers)/\(questionsAmount)
            Количество сыгранных квизов: \(service.gamesCount)
            Рекорд: \(service.bestGame.correct)/\(service.bestGame.total) (\(service.bestGame.date.dateTimeString))
            Средняя точность: \(String(format: "%.2f", service.totalAccuracy))%
            """
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            showResult(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            buttonState()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        buttonState(isEnabled: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResult()
            self.imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    private func buttonState(isEnabled: Bool = true) {
        answerButtons[0].isEnabled = isEnabled
        answerButtons[1].isEnabled = isEnabled
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(
            title: "Что-то пошло не так(",
            message: message,
            buttonText: "Попробовать еще раз") { [weak self] in
                guard let self = self else { return }
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.loadData()
                self.questionFactory?.requestNextQuestion()
            }
        alertPresenter?.showAlert(model: model)
    }
}
