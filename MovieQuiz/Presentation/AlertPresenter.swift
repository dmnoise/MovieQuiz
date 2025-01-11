//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Dmitriy Noise on 10.01.2025.
//

import UIKit

class AlertPresenter {
    private var model: AlertModel
    
    init(from alertModel: AlertModel) {
        self.model = alertModel
    }
    
    func presentAlert(from viewController: UIViewController) {
        // Создаём объекты всплывающего окна
        let alert = UIAlertController(title: model.title, // заголовок всплывающего окна
                                      message: model.message, // текст во всплывающем окне
                                      preferredStyle: .alert)
        
        // Создаём для алерта кнопку с действием
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            self.model.closure()
        }
        
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
