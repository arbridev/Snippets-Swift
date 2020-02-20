//
//  CameraHandler.swift
//  theappspace.com
//
//  Based on code created by Dejan Atanasov on 26/06/2017.
//  Copyright © 2017 Dejan Atanasov. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import Photos

// Singleton
class CameraHandler: NSObject {
    
    /*
    enum CameraHandlerError: Error {
        case cameraNotResponding
        case libraryNotResponding
    }
     */
    
    static let shared = CameraHandler()
    
    fileprivate var currentVC: UIViewController!
    
    var imagePickedBlock: ((UIImage) -> Void)?
    
    var maxImageFileSize: CGFloat?
    
    func camera() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    DispatchQueue.main.async {
                        let myPickerController = UIImagePickerController()
                        myPickerController.delegate = self
                        myPickerController.sourceType = .camera
                        self.currentVC.present(myPickerController, animated: true, completion: nil)
                    }
                }
            } else {
                fatalError("Camera error")
            }
        }
    }
    
    func camera(viewController: UIViewController) {
        self.currentVC = viewController
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    DispatchQueue.main.async {
                        let myPickerController = UIImagePickerController()
                        myPickerController.delegate = self
                        myPickerController.sourceType = .camera
                        self.currentVC.present(myPickerController, animated: true, completion: nil)
                    }
                }
            } else {
                fatalError("Camera error")
            }
        }
    }
    
    func photoLibrary() {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ status in
                if status == .authorized {
                    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                        DispatchQueue.main.async {
                            let myPickerController = UIImagePickerController()
                            myPickerController.delegate = self
                            myPickerController.sourceType = .photoLibrary
                            self.currentVC.present(myPickerController, animated: true, completion: nil)
                        }
                    }
                } else {
                    fatalError("Photo library error")
                }
            })
        } else if photos == .authorized {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                DispatchQueue.main.async {
                    let myPickerController = UIImagePickerController()
                    myPickerController.delegate = self
                    myPickerController.sourceType = .photoLibrary
                    self.currentVC.present(myPickerController, animated: true, completion: nil)
                }
            }
        } else {
            fatalError("Photo library error")
        }
    }
    
    func showActionSheet(vc: UIViewController, anchor: UIView) {
        currentVC = vc
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = anchor
            popoverController.sourceRect = anchor.bounds
        }
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    fileprivate func resizeImageFile(_ image: UIImage, toMaxSize maxSize: CGFloat) -> UIImage? {
        
        var fileSize = image.getJPEGFileSize()
        var mutatingImage: UIImage? = image
        while CGFloat(fileSize) > maxSize {
            var okPercentage: CGFloat = 0
            let difference = CGFloat(fileSize) - maxSize
            
            switch difference {
            case 0...99:
                okPercentage = 95
            case 100...399:
                okPercentage = 90
            case 400...799:
                okPercentage = 80
            case 800...1499:
                okPercentage = 60
            case 1500...2999:
                okPercentage = 50
            case 3000...6000:
                okPercentage = 40
            default:
                okPercentage = 30
            }
            
            mutatingImage = mutatingImage?.resized(withPercentage: okPercentage/100.0)
            fileSize = (mutatingImage ?? UIImage()).getJPEGFileSize()
        }
        return mutatingImage
    }
    
}


extension CameraHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /*
    enum CameraHandlerImagePickerError: Error {
        case pickingMedia
    }
     */
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if var image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let maxSize = maxImageFileSize {
                image = resizeImageFile(image, toMaxSize: maxSize) ?? UIImage()
            }
            self.imagePickedBlock?(image)
        } else {
            fatalError("Error picking media")
        }
        currentVC.dismiss(animated: true, completion: nil)
    }
    
}
