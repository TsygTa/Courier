//
//  Path.swift
//  Courier
//
//  Created by Tatiana Tsygankova on 07/08/2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import Foundation
import RealmSwift
import GoogleMaps

/// Класс маршрута
public class Path: Object {
    
    @objc dynamic var id: Int = 1
    @objc dynamic var encodedPath: String = ""
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    convenience init(path: GMSMutablePath) {
        self.init()
        self.encodedPath = path.encodedPath()
    }
}
