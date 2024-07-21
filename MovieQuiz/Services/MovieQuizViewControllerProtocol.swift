//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Nurbol on 21.07.2024.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func showQuestion(quiz step: QuizStepViewModel)
    func showResult(quiz result: QuizResultsViewModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    func buttonState(isEnabled: Bool)
    func clear()
}
