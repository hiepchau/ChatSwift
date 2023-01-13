//
//  ChatViewController+ActionSheet.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 09/01/2023.
//

import Foundation
import UIKit

extension ChatViewController {
    
    //MARK: - Action sheet
        func presentInputActionSheet() {
            let actionSheet = UIAlertController(title: "Attach Media",
                                                message: "What would you like to attach?",
                                                preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Photo", style: .default, handler: { [weak self] _ in
                self?.presentPhotoInputActionsheet()
            }))
            actionSheet.addAction(UIAlertAction(title: "Video", style: .default, handler: { [weak self]  _ in
                self?.presentVideoInputActionsheet()
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
            present(actionSheet, animated: true)
        }
    
        private func presentPhotoInputActionsheet() {
            let actionSheet = UIAlertController(title: "Attach Photo",
                                                message: "Where would you like to attach a photo from",
                                                preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                picker.allowsEditing = true
                self?.present(picker, animated: true)
            }))
    
            actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = true
                self?.present(picker, animated: true)
    
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
            present(actionSheet, animated: true)
        }
    
        private func presentVideoInputActionsheet() {
            let actionSheet = UIAlertController(title: "Attach Video",
                                                message: "Where would you like to attach a video from?",
                                                preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                picker.mediaTypes = ["public.movie"]
                picker.videoQuality = .typeMedium
                picker.allowsEditing = true
                self?.present(picker, animated: true)
    
            }))
            actionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: { [weak self] _ in
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = true
                picker.mediaTypes = ["public.movie"]
                picker.videoQuality = .typeMedium
                self?.present(picker, animated: true)
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(actionSheet, animated: true)
        }
}
