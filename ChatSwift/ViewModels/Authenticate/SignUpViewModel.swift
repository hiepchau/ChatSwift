//
//  SignUpViewModel.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 03/01/2023.
//

import Foundation
import UIKit

//TODO: HANDLE SIGNUP

class SignUpViewModel: BaseViewModel {
    
    //MARK: - Variables
    private var imgProfile = UIImageView()
    private var username = ""
    private var email = ""
    private var password = ""
    private var confirmPassword = ""
    
    //MARK: - Update variables
    
    func observeTextChange(text: String?){
        self.username = text ?? ""
        self.password = text  ?? ""
        self.email = text ?? ""
        self.confirmPassword = text ?? ""
    }
    
    //MARK: - Function
    
    func signup() {
        validate()    }
    
    func validate() {
        let imgSystem = UIImage(named: "profile")
        
        if imgProfile.image?.pngData() != imgSystem?.pngData(){
            // profile image selected
                if username == ""{
                    print("Please enter username")
                } else if !email.validateEmailId(){
                    print("email is not valid")
                } else if !password.validatePassword(){
                    print("Password is not valid")
                } else{
                    if confirmPassword == ""{
                        print("Please confirm password")
                    }else{
                        if password == confirmPassword{
                            // navigation code
                            print("Nice!")
                        } else{
                            print("password does not match")
                        }
                    }
                }
            
        } else{
            print("Please select profile picture")
        }
    }
}
