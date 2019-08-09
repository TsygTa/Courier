//
//  LoginViewController.swift
//  Courier
//
//  Created by Tatiana Tsygankova on 08/08/2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

    @IBOutlet var router: LoginRouter!
    
    @IBOutlet weak var loginTextView: UITextField!
    
    @IBOutlet weak var passwordTextView: UITextField!
    
    
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

        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(hideKeyboardGesture)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
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
