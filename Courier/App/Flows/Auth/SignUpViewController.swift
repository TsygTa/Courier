//
//  SignUpViewController.swift
//  Courier
//
//  Created by Tatiana Tsygankova on 08/08/2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import UIKit

final class SignUpViewController: UIViewController {
    
    @IBOutlet weak var loginTextView: UITextField!
    
    @IBOutlet weak var passwordTextView: UITextField!
    
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
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(hideKeyboardGesture)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
}
