//
//  SelfieViewController.swift
//  Courier
//
//  Created by Tatiana Tsygankova on 27/08/2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import UIKit

class SelfieViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func takePhoto(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = PhotoService.getPhoto()
    }
}

// MARK: - Реализует методы UIImagePickerControllerDelegate
extension SelfieViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: true) { [weak self] in
            guard let self = self,
                let image = self.extractImage(from: info) else { return }
            self.setPicture(image: image)
        }
    }
    
    private func extractImage(from info: [UIImagePickerController.InfoKey: Any]) -> UIImage? {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            return image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            return image
        } else {
            return nil
        }
    }
    
    private func setPicture(image: UIImage) {
        self.imageView.image = image
        PhotoService.savePhoto(image: image)
    }
}
