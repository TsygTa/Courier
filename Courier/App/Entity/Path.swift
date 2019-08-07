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

public class Path: Object {
    
    @objc dynamic var encodedPath: String = ""
    
    convenience init(path: GMSMutablePath) {
        self.init()
        self.encodedPath = path.encodedPath()
    }
}
