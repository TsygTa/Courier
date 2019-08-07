//
//  Session.swift
//  Courier
//
//  Created by Tatiana Tsygankova on 31/07/2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import Foundation

/// Класс сессии
public class Session {
    static let instance = Session()
    
    /// Указывает стартовано ли отслеживаниие местоположения
    var isMyLocationUpdating: Bool = false
    
    /// Текущий масштаб карты
    var mapZoomLevel: Float = 17
    
    private init() {}
}
