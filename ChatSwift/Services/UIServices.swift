//
//  UIServices.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 30/12/2022.
//

import Foundation
import UIKit

internal class ListenerService: NSObject, UITextFieldDelegate {
    
    static let shared = ListenerService()
    var viewModel = BaseViewModel()
    internal func textWatcher(textField: UITextField!, view: UIViewController!, viewModel: BaseViewModel) {
        textField.delegate = self
        textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.viewModel = viewModel
    }
    
    @objc internal func textFieldDidChange(_ textField: UITextField) {
        viewModel.setDynamicTextField(text: textField.text, tag: textField.tag)
    }
}

