//
//  SignUpTableViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 23/12/2022.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgProfile.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        openGallery()
    }
    
    @IBAction func btnSignupClicked(_ sender: UIButton) {
        let imgSystem = UIImage(named: "profile")
        
        if imgProfile.image?.pngData() != imgSystem?.pngData(){
            // profile image selected
            if let email = emailField.text, let password = passwordField.text, let username = usernameField.text, let conPassword = confirmPasswordField.text{
                if username == ""{
                    print("Please enter username")
                }else if !email.validateEmailId(){
                    openAlert(title: "Alert", message: "Please enter valid email", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in }])
                    print("email is not valid")
                }else if !password.validatePassword(){
                    print("Password is not valid")
                } else{
                    if conPassword == ""{
                        print("Please confirm password")
                    }else{
                        if password == conPassword{
                            // navigation code
                            print("Navigation code Yeah!")
                        }else{
                            print("password does not match")
                        }
                    }
                }
            }else{
                print("Please check your details")
            }
        }else{
            print("Please select profile picture")
            openAlert(title: "Alert", message: "Please select profile picture", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in }])
        }
    }
    
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UIScreen.main.bounds.height
//    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        let tableViewHeight = self.tableView.frame.height
//        let contentHeight = self.tableView.contentSize.height
//
//        let centeringInset = (tableViewHeight - contentHeight) / 2.0
//        let topInset = max(centeringInset, 0.0)
//
//        self.tableView.contentInset = UIEdgeInsets(top: topInset, left: 0.0, bottom: 0.0, right: 0.0)
//    }
}

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
