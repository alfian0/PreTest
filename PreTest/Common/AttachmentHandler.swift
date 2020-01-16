//
//  AttachmentHandler.swift
//  PreTest
//
//  Created by alpiopio on 16/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos

enum AttachmentType: String{
    case camera
    case file
    case photoLibrary
}

protocol AttachmentHandlerDelegate: class {
    func didSelectFile(with data: URL, attachment: AttachmentHandler)
}

class AttachmentHandler: NSObject {
    private var items: [AttachmentType] = []
    private var currentViewController: UIViewController?
    weak var delegate: AttachmentHandlerDelegate?
    
    init(items: [AttachmentType] = [.camera, .photoLibrary, .file]) {
        self.items = items
    }
    
    func showAttachmentActionSheet(viewController: UIViewController) {
        currentViewController = viewController
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for item in items {
            switch item {
            case .camera:
                alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                    self.authorisationStatus(attachmentType: .camera, viewController: viewController)
                }))
            case .photoLibrary:
                alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
                    self.authorisationStatus(attachmentType: .photoLibrary, viewController: viewController)
                }))
            case .file:
                alert.addAction(UIAlertAction(title: "File", style: .default, handler: { (_) in
                    self.documentPicker()
                }))
            }
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.currentViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func authorisationStatus(attachmentType type: AttachmentType, viewController: UIViewController){
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            switch type {
            case .camera:
                openCamera()
            case .photoLibrary:
                photoLibrary()
            default: break
            }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                switch status {
                case .authorized:
                    switch type {
                    case .camera:
                        self.openCamera()
                    case .photoLibrary:
                        self.photoLibrary()
                    default: break
                    }
                default:
                    self.addAlertForSettings(attachmentType: type)
                }
            })
        case .denied,
             .restricted:
            self.addAlertForSettings(attachmentType: type)
        default: break
        }
    }
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            DispatchQueue.main.async {
                self.currentViewController?.present(myPickerController, animated: true, completion: nil)
            }
        }
    }
    
    func photoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            DispatchQueue.main.async {
                self.currentViewController?.present(myPickerController, animated: true, completion: nil)
            }
        }
    }
    
    func documentPicker(){
        let importMenu = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        DispatchQueue.main.async {
            self.currentViewController?.present(importMenu, animated: true, completion: nil)
        }
    }
    
    func addAlertForSettings(attachmentType type: AttachmentType){
        var title: String
        var body: String
        switch type {
        case .camera:
            title = ""
            body = "App does not have access to your camera. To enable access, tap settings and turn on Camera."
        case .photoLibrary:
            title = ""
            body = "App does not have access to your photos. To enable access, tap settings and turn on Photo Library Access."
        case .file:
            title = ""
            body = ""
        }
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
            let settingsUrl = NSURL(string: UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }))
        DispatchQueue.main.async {
            self.currentViewController?.present(alert, animated: true, completion: nil)
        }
    }
}

extension AttachmentHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        DispatchQueue.main.async {
            self.currentViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imgName = String(Date().timeIntervalSince1970) + ".jpg"
        let documentDirectory = NSTemporaryDirectory()
        let localPath = documentDirectory.appending(imgName)
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let data = image.jpegData(compressionQuality: 0.1)! as NSData
        data.write(toFile: localPath, atomically: true)
        let photoURL = URL.init(fileURLWithPath: localPath)
        DispatchQueue.main.async {
            self.currentViewController?.dismiss(animated: true, completion: {
                self.delegate?.didSelectFile(with: photoURL, attachment: self)
            })
        }
    }
}

extension AttachmentHandler: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        // https://stackoverflow.com/questions/37109130/uidocumentpickerviewcontroller-returns-url-to-a-file-that-does-not-exist
        // Create file URL to temporary folder
        var tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
        // Apend filename (name+extension) to URL
        tempURL.appendPathComponent(url.lastPathComponent)
        do {
            // If file with same name exists remove it (replace file with new one)
            if FileManager.default.fileExists(atPath: tempURL.path) {
                try FileManager.default.removeItem(atPath: tempURL.path)
            }
            // Move file from app_id-Inbox to tmp/filename
            try FileManager.default.moveItem(atPath: url.path, toPath: tempURL.path)
            delegate?.didSelectFile(with: tempURL, attachment: self)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        DispatchQueue.main.async {
            self.currentViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
