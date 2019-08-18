//
//  LoginViewController.swift
//  Courier
//
//  Created by Tatiana Tsygankova on 08/08/2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController, Authorizable {

    @IBOutlet var router: LoginRouter!
    
    @IBOutlet weak var loginTextView: UITextField!
    
    @IBOutlet weak var passwordTextView: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func login(_ sender: Any) {
        
        guard let login = loginTextView.text, !login.isEmpty,
            let password = passwordTextView.text, !password.isEmpty else {
                self.showAlert(error: "Enter login and password.")
                return
        }
        
        guard let user = DatabaseService.getData(type: User.self)?.filter("login = %@ && password = %@", login, password).first else {
            self.showAlert(error: "Login or password is wrong.")
            return
        }
        Session.instance.user = user
        UserDefaults.standard.set(true, forKey: "isLogin")
        router.toMain()
    }
    
    @IBAction func signUp(_ sender: Any) {
        router.signUp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginTextView.autocorrectionType = .no
        
        configureLoginBindings()
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(hideKeyboardGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearAuthFields()
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    /// Конфигурирует кнопку входа
    func configureLoginBindings() {
        Observable
            .combineLatest(loginTextView.rx.text, passwordTextView.rx.text)
            .map {login, password in
                return !(login ?? "").isEmpty && (password ?? "").count >= 6
            }
            .bind { [weak loginButton] inputFilled in
                loginButton?.isEnabled = inputFilled
            }
    }
}

// MARK: - Расширение LoginViewController, реализующее протокол Authorizable
extension LoginViewController {
    /// Очищает поля авторизациии
    func clearAuthFields() {
        self.loginTextView.text = nil
        self.passwordTextView.text = nil
    }
}

/// Класс роутера для навигации по экранам авторизации
final class LoginRouter: BaseRouter {
    func toMain() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(MainViewController.self)
        setAsRoot(UINavigationController(rootViewController: controller))
    }
    
    func signUp() {
        let controller = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(SignUpViewController.self)
        show(controller)
    }
}
