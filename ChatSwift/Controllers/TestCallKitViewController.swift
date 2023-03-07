//
//  TestCallKitViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 24/02/2023.
//

import UIKit
import CallKit

class TestCallKitViewController: UIViewController, CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        <#code#>
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: "Hiep Chau")
        
        let config = CallKit.CXProviderConfiguration()
        config.includesCallsInRecents = true
        config.supportsVideo = true

        let provider = CXProvider(configuration: config)
        provider.setDelegate(self, queue: nil)
        provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
