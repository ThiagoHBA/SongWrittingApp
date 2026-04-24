import Foundation
import UIKit

public protocol AlertPresentable { }

extension AlertPresentable where Self: UIViewController {
    public func showAlert(title: String, message: String, dismissed: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: dismissed)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
