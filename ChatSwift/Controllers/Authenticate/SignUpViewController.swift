//
//  SignUpViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 03/01/2023.
//

import UIKit

class SignUpViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    //ViewModel
    let viewModel = SignUpViewModel()
    
    //MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        //TODO: Remove #selector
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgProfile.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - IBActions
    
    @objc
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        openGallery()
    }
    
    @IBAction func signupButtonDidTouch(_ sender: UIButton) {
        viewModel.signup()
    }
    
    @IBAction func loginButtonDidTouch(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}



//MARK: - Extensions
extension SignUpViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .savedPhotosAlbum
            present(picker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.originalImage] as? UIImage{
            imgProfile.image = img
        }
        dismiss(animated: true)
    }
}

