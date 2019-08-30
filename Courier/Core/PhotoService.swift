//
//  PhotoService.swift
//  Courier
//
//  Created by Tatiana Tsygankova on 28/08/2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import Foundation
import UIKit

/// Класс для сохранения (чтения) фото в файле
public class PhotoService {
    
    /// Путь к файлу для сохранения фото
    private static let pathName: String? = {
        
        let pathName = "selfie"
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let url = documentsDirectory.appendingPathComponent(pathName).path
        
        return url
    } ()
    
    /// Сохраняет фото
    ///
    /// - Parameter image: фото
    static func savePhoto(image: UIImage) {
        guard let fileName = PhotoService.pathName else { return }
        
        if FileManager.default.fileExists(atPath: fileName) {
            do {
                try FileManager.default.removeItem(atPath: fileName)
            } catch {
                print(error)
            }
        }
        
        let data = image.pngData()
        
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }
    
    /// Получает фото из файла
    ///
    /// - Returns: фото
    static func getPhoto() -> UIImage? {
        
        guard let fileName = PhotoService.pathName,
            FileManager.default.fileExists(atPath: fileName)
             else { return UIImage(named: "emptyImage.png")}
        
        let image = UIImage(contentsOfFile: fileName)
        
        return image
    }
}
