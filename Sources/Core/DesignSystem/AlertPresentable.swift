//
//  AlertPresentable.swift
//  UI
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation
import UIKit

protocol AlertPresentable { }

extension AlertPresentable where Self: UIViewController {
    func showAlert(title: String, message: String, dismissed: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: dismissed)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
