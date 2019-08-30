//
//  MainViewController.swift
//  Courier
//
//  Created by Tatiana Tsygankova on 09/08/2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import UIKit

/// Контроллер главного экрана
class MainViewController: UIViewController {
    
    @IBOutlet var router: MainRouter!
    
    
    @IBAction func showMap(_ sender: Any) {
        router.toMap()
    }
    
    @IBAction func logout(_ sender: Any) {
        router.logout()
    }
    
    @IBAction func takePicture(_ sender: Any) {
        router.toSelfie()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

/// Класс роутера для навигации по главным экранам
final class MainRouter: BaseRouter {
    func toMap() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(MapViewController.self)
        show(controller)
    }
    
    func logout() {
        let controller = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(LoginViewController.self)
        setAsRoot(UINavigationController(rootViewController: controller))
        UserDefaults.standard.set(false, forKey: "isLogin")
    }
    
    func toSelfie() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(SelfieViewController.self)
        show(controller)
    }
}
