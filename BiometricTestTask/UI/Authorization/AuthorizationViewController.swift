//
//  AuthorizationViewController.swift
//  BiometricTestTask
//
//  Created by Ivan Apet on 08.10.2020.
//

import UIKit

import RxSwift
import RxCocoa

final class AuthorizationViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var biometricBtn: UIButton!
    
    private let bag = DisposeBag()
    private let authService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        tapToCloseKeboard()
        subscribeTF()
        setupBtn()
        subscribeOnBiometric()
    }
}

//MARK: -
//MARK: - Auth logic

private extension AuthorizationViewController {
    func successAuth(isBiometric: Bool = true) {
        view.backgroundColor = .green
        view.endEditing(true)
        if isBiometric {
            textField.text = "1111"
        }
        let delay = isBiometric ? 1 : 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let vc = ProfileViewController.loadFromNib()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func checkString(text: String) {
        guard let pin = UserDefaults.standard.value(forKey: "pin") as? String else {return}
        if text.count > 4 {
            textField.shake()
            textField.text = String(text.prefix(4))
        }
        if text == pin {
            successAuth(isBiometric: false)
        }
        if text.count == pin.count, text != pin {
            textField.shake()
            showAlert(title: "Не верный пин",
                      btnText: "Попробовать еще раз")
        }
    }
    
    func failAlert() {
        showAlert(title: "Биометрический пароль недоступен",
                  message: "Разблокируйте устройство с помощью пинкода девайса",
                  btnText: "Ок")
    }
}

//MARK: -
//MARK: - Configure

private extension AuthorizationViewController {
    func configure() {
        view.backgroundColor = .red
        navigationController?.setNavigationBarHidden(true, animated: false)
        textField.isSecureTextEntry = true
        textField.keyboardType = .numberPad
        textField.makeCorners()
    }
    
    func setupBtn() {
        biometricBtn.rx.tap.subscribe(onNext: {[weak self] in
            self?.subscribeOnBiometric()
        })
        .disposed(by: bag)
    }
    
    func subscribeTF() {
        textField.rx.controlEvent(.editingChanged).asObservable().subscribe({[weak self] _ in
            guard let self = self, let text = self.textField.text else {return}
            self.checkString(text: text)
        })
        .disposed(by: bag)
    }
    
    func subscribeOnBiometric() {
        authService.createObservableBiometric().subscribe { [weak self] (event) in
            guard let error = event.error else {
                self?.successAuth(isBiometric: true)
                return
            }
            self?.showAlert(title: "Ошибка", message: error.localizedDescription, btnText: "Ок")
        }
        .disposed(by: bag)
    }
}

//MARK: -
//MARK: - Alert

private extension AuthorizationViewController {
    func showAlert(title: String, message: String? = nil, btnText: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: btnText, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
