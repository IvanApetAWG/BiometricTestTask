//
//  RegistrationViewController.swift
//  BiometricTestTask
//
//  Created by Ivan Apet on 08.10.2020.
//

import UIKit
import RxCocoa
import RxSwift

class RegistrationViewController: UIViewController {

    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var regBtn: UIButton!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        tapToCloseKeboard()
    }

    @IBAction func regAction(_ sender: Any) {
        let vc = ProfileViewController.loadFromNib()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RegistrationViewController {
    func configure() {
        title = "Регистрация"
        
        loginTF.baseSetup(placeholder: "Логин")
        passTF.baseSetup(placeholder: "Пароль")
        
        passTF.textContentType = .password
        passTF.isSecureTextEntry = true
        
        regBtn.makeCorners()
        regBtn.backgroundColor = .blue
        regBtn.setTitleColor(.white, for: .normal)
        regBtn.setTitleColor(.gray, for: .disabled)
    }
}
