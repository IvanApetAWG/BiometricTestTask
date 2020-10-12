//
//  ProfileViewController.swift
//  BiometricTestTask
//
//  Created by Ivan Apet on 08.10.2020.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var pinTF: UITextField!
    @IBOutlet weak var setPinBtn: UIButton!

    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        tapToCloseKeboard()
        rxSetup()
    }
}

//MARK: -
//MARK: - Logic

private extension ProfileViewController {
    func setupBtn(pinDidSet: Bool) {
        setPinBtn.backgroundColor = pinDidSet ? .red : .green
        setPinBtn.setTitle(pinDidSet ? "Удалить пин" : "Установить пин", for: .normal)
    }
    
    func isPinExist() -> Bool {
        (UserDefaults.standard.value(forKey: "pin") as? String) != nil
    }
    
    func setLimitedText() {
        pinTF.text = String(pinTF.text?.prefix(4) ?? "")
    }
    
    func btnTap() {
        if isPinExist() {
            UserDefaults.standard.setValue(nil, forKey: "pin")
            sucessAlert(title: "Текущий пин удален")
            pinTF.text?.removeAll()
            pinTF.sendActions(for: .valueChanged)
        } else if let text = pinTF.text, text.count == 4 {
            UserDefaults.standard.setValue(text, forKey: "pin")
            view.endEditing(true)
            sucessAlert(title: "Установлен новый пин!")
        } else if pinTF.text?.isEmpty ?? true {
            pinTF.shake()
        }
    }
}

//MARK: -
//MARK: - Configure

private extension ProfileViewController {
    func configure() {
        title = "Профиль"
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.setHidesBackButton(true, animated: false)
        
        pinTF.baseSetup(placeholder: "Пин")
        pinTF.keyboardType = .decimalPad
        
        setPinBtn.makeCorners()
        setPinBtn.backgroundColor = .green
        setPinBtn.setTitleColor(.black, for: .normal)
        
        if let code = UserDefaults.standard.value(forKey: "pin") as? String, code.count == 4 {
            pinTF.text = code
            pinTF.sendActions(for: .valueChanged)
        }
    }
    
    func rxSetup() {
        pinTF.rx.controlEvent(.editingChanged)
            .subscribe(onNext: {[weak self] in self?.setLimitedText() })
            .disposed(by: bag)
        
        pinTF.rx.text.orEmpty
            .map { [weak self] in $0.count == 4 && self?.isPinExist() ?? false }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in self?.setupBtn(pinDidSet: $0) })
            .disposed(by: bag)
        
        setPinBtn.rx.tap
            .subscribe(onNext: {[weak self] _ in self?.btnTap() })
            .disposed(by: bag)
    }
}

//MARK: -
//MARK: - Alert

private extension ProfileViewController {
    func sucessAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
