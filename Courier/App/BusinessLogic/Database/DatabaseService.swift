//
//  DatabaseService.swift
//  Courier
//
//  Created by Tatiana Tsygankova on 06/08/2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import RealmSwift

/// Класс сервиса работы с базой данных
public class DatabaseService {
    
    static func saveData<Element: Object>(data: Element, config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)) {
        do {
            print(config.fileURL ?? "")
            let realm = try Realm(configuration: config)
            realm.beginWrite()
            realm.add(data)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    static func deleteData<Element: Object>(type: Element.Type, config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)) {
        do {
            print(config.fileURL ?? "")
            let realm = try Realm(configuration: config)
            let oldData = realm.objects(type)
            
            realm.beginWrite()
            realm.delete(oldData)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    static func getData<Element: Object>(type: Element.Type, config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)) -> Results<Element>? {
        let realm = try? Realm(configuration: config)
        return realm?.objects(type)
    }
}
