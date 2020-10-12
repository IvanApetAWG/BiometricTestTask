//
//  ViewController.swift
//  BiometricTestTask
//
//  Created by Ivan Apet on 08.10.2020.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAuthentication()
    }
    
    func startAuthentication() {
        let contet = LAContext()
        let reason = "Biometric Authntication testing !!"
        var authError: NSError?
        
        if contet.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            contet.localizedCancelTitle = "Cancel"
            contet.localizedFallbackTitle = ""
            contet.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, evaluateError in
                DispatchQueue.main.async {
                    if success {
                        self.showSuccessAlert()
                    } else {
                        // User did not authenticate successfully, look at error and take appropriate action
                        print(evaluateError?.localizedDescription)
                    }
                }
            }
            return
        }
        // Could not evaluate policy; look at authError and present an appropriate message to user
        print("Sorry!!.. Could not evaluate policy.\(authError?.localizedDescription)")
    }
    
    
    func showSuccessAlert() {
//        let alert = UIAlertController(title: "Success", message: "Successfully Authenticated", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//        present(alert, animated: true, completion: nil)
        
        let vc = RegistrationViewController.loadFromNib()
        present(vc, animated: true, completion: nil)
    }
}

