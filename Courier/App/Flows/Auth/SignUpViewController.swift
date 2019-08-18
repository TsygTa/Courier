//
//  SignUpViewController.swift
//  Courier
//
//  Created by Tatiana Tsygankova on 08/08/2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: UIViewController, Authorizable {
    
    @IBOutlet weak var loginTextView: UITextField!
    
    @IBOutlet weak var passwordTextView: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func signUp(_ sender: Any) {
        
        guard let login = loginTextView.text, !login.isEmpty,
            let password = passwordTextView.text, !password.isEmpty else {
                self.showAlert(error: "Enter login and password.")
                return
        }
        
        let user: User = User(login: login, password: password)
        
        DatabaseService.saveData(data: user)
        self.showAlert(title: "Attention", message: "User was registered!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginTextView.autocorrectionType = .no
        
        configureSignUpBindings()
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(hideKeyboardGesture)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    /// Конфигурирует кнопку регистрации
    func configureSignUpBindings() {
        Observable
            .combineLatest(loginTextView.rx.text, passwordTextView.rx.text)
            .map {login, password in
                return !(login ?? "").isEmpty && (password ?? "").count >= 6
            }
            .bind { [weak signUpButton] inputFilled in
                signUpButton?.isEnabled = inputFilled
        }
    }
}

// MARK: - Расширение SignUpViewController, реализующее протокол Authorizable
extension SignUpViewController {
    /// Очищает поля авторизациии
    func clearAuthFields() {
        self.loginTextView.text = nil
        self.passwordTextView.text = nil
    }
}
