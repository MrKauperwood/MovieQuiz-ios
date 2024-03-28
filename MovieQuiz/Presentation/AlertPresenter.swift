//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Aleksei Bondarenko on 21.2.2024.
//

import Foundation
import UIKit

final class AlertPresenter {
    func present(alertModel: AlertModel, on viewController: UIViewController) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: alertModel.buttonText,
            style: .default
        ) { _ in
            alertModel.completion()
        }

        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
}