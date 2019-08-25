//
//  User.swift
//  Courier
//
//  Created by Tatiana Tsygankova on 08/08/2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import Foundation
import RealmSwift

/// Класс пользователя
public class User: Object {
    
    @objc dynamic var login: String = ""
    @objc dynamic var password: String = ""
    
    override public static func primaryKey() -> String? {
        return "login"
    }
    convenience init(login: String, password: String) {
        self.init()
        self.login = login
        self.password = password
    }
}
