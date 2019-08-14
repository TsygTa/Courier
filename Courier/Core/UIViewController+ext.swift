//
//  UIViewController+ext.swift
//  Courier
//
//  Created by Tatiana Tsygankova on 31/07/2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import Foundation
import UIKit

public protocol Authorizable {
    func clearAuthFields()
}

// MARK: - Содержит методы, расширяющие UIViewController
extension UIViewController {
    /// Выводит окно с ошибкой
    ///
    /// - Parameter error: ошибка
    func showAlert(error: Error) {
        let alertVC = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    /// Выводит окно с ошибкой
    ///
    /// - Parameter error: строка с ошибкой
    func showAlert(error: String) {
        let alertVC = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertVC.addAction(action)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    /// Выводит окно с сообщением
    ///
    /// - Parameters:
    ///   - title: строка с заголовком окна
    ///   - message: строка с сообщением
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertVC.addAction(action)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    /// Выводит окно с сообщением ии выполняет некоторые действиия после нажатия кнопки Ок
    ///
    /// - Parameters:
    ///   - title: строка с заголовком окно
    ///   - message: строка с сообщением
    ///   - withCancel: флаг наличия кнопки Отмена, по-умолчаниию - false
    ///   - handler: обработчик нажатия кнопки Ок
    func showAlert(title: String, message: String, withCancel: Bool = false, handler: @escaping (UIAlertAction)->Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Ok", style: .destructive, handler: handler)
        
        alertVC.addAction(confirmAction)
        
        if withCancel {
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        }
        
        present(alertVC, animated: true, completion: nil)
    }
}

/// Протокол для объектов, имеющих идентификатор в сториборде
protocol StoryboardIdentifiable {
    static var storybboardIdentifier: String { get }
}

// MARK: - Расширение для UIViewController, которое дает совместимость
// с протоколом StoryboardIdentifiable
extension UIViewController: StoryboardIdentifiable {}

// MARK: - Расшиирение StoryboardIdentifiable для UIViewController,
// создающее идентификатор в сториборде, равный названию класса контроллера
extension StoryboardIdentifiable where Self: UIViewController {
    static var storybboardIdentifier: String {
        return String(describing: self)
    }
}

// MARK: - Расшиирение UIStoryboard - для поиска контроллера по его идентификатору в сториборде
extension UIStoryboard {
    func instantiateViewController<T: UIViewController>(_: T.Type) -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storybboardIdentifier) as? T else {
            fatalError("View controller with identifier \(T.storybboardIdentifier) is not found")
        }
        return viewController
    }
    
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storybboardIdentifier) as? T else {
            fatalError("View controller with identifier \(T.storybboardIdentifier) is not found")
        }
        return viewController
    }
}
