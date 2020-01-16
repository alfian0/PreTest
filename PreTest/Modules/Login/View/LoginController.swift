//
//  LoginController.swift
//  PreTest
//
//  Created by alpiopio on 16/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import UIKit
import CoreLocation

protocol LoginView: class {
    func setupPage(with state: PageState)
}

class LoginController: UIViewController {
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private lazy var viewModel: LoginViewModel = {
        let viewModel = LoginViewModel()
        viewModel.delegate = self
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Login"
        login.addTarget(self, action: #selector(loginTapped(_:)), for: .touchUpInside)
        let location = UserLocationManager.instance
        location.delegate = self
    }
    
    @objc
    private func loginTapped(_ sender: UIButton) {
        viewModel.login(phone: phone.text, password: password.text)
    }
}

extension LoginController: LoginView {
    func setupPage(with state: PageState) {
        DispatchQueue.main.async {
            switch state {
            case .loading:
                self.login.isEnabled = false
            case .success:
                self.login.isEnabled = true
                self.navigationController?.setViewControllers([ProfileController()], animated: false)
            case .error(let message):
                self.login.isEnabled = true
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
                self.navigationController?.present(alert, animated: true, completion: nil)
            default: break
            }
        }
    }
}

extension LoginController: UserLocationDelegate {
    func locationDidUpdateToLocation(location: CLLocation) {
        viewModel.setCoordinate(with: location)
    }
}
