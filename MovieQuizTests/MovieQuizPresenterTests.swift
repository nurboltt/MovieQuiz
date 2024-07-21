//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Nurbol on 21.07.2024.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func buttonState(isEnabled: Bool) { }
    func clear() {}
    func showQuestion(quiz step: MovieQuiz.QuizStepViewModel) { }
    func showResult(quiz result: MovieQuiz.QuizResultsViewModel) { }
    func highlightImageBorder(isCorrectAnswer: Bool) { }
    func showLoadingIndicator() { }
    func hideLoadingIndicator() { }
    func showNetworkError(message: String) { }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock: MovieQuizViewControllerProtocol = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
