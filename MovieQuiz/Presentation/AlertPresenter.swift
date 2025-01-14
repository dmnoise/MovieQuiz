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
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            self.model.closure()
        }
        
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
