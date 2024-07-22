//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Nurbol on 20.06.2024.
//

import UIKit

final class AlertPresenter {
    
    private weak var movieVC: MovieQuizViewController?
    
    init(movieVC: MovieQuizViewController) {
        self.movieVC = movieVC
    }
    
    func showAlert(model: AlertModel) {
        
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "alert"
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        
        alert.addAction(action)
        movieVC?.present(alert, animated: true, completion: nil)
    }
}
