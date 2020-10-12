//
//  AuthService.swift
//  BiometricTestTask
//
//  Created by Ivan Apet on 11.10.2020.
//

import UIKit
import LocalAuthentication
import RxSwift
import RxCocoa

final class AuthService {
    
    @discardableResult
    func createObservableBiometric() -> Observable<Bool> {
        Observable.create { (observer) -> Disposable in
            let contet = LAContext()
            let reason = "Biometric Authntication testing !!"
            var authError: NSError?
            if contet.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                contet.localizedCancelTitle = "Cancel"
                contet.localizedFallbackTitle = ""
                contet.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, evaluateError in
                    DispatchQueue.main.async {
                        if success {
                            observer.onNext(true)
                        } else {
                            observer.onError(evaluateError!)
                        }
                    }
                }
            }
//            self.failAlert()
            return Disposables.create()
        }
    }
}
