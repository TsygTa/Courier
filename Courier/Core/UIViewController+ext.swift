//
//  UIViewController+ext.swift
//  Courier
//
//  Created by Tatiana Tsygankova on 31/07/2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import Foundation
import UIKit

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
        let alter = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alter.addAction(action)
        
        present(alter, animated: true, completion: nil)
    }
    
    /// Выводит окно с сообщением
    ///
    /// - Parameters:
    ///   - title: строка с заголовком окна
    ///   - message: строка с сообщением
    func showAlert(title: String, message: String) {
        let alter = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alter.addAction(action)
        
        present(alter, animated: true, completion: nil)
    }
    
    /// Выводит окно с сообщением ии выполняет некоторые действиия после нажатия кнопки Ок
    ///
    /// - Parameters:
    ///   - title: строка с заголовком окно
    ///   - message: строка с сообщением
    ///   - handler: обработчик нажатия кнопки Ок
    func showAlert(title: String, message: String, handler: @escaping (UIAlertAction)->Void) {
        let alter = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: handler)
        
        alter.addAction(action)
        
        present(alter, animated: true, completion: nil)
    }
}
