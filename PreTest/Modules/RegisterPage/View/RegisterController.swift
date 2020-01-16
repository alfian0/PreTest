//
//  RegisterController.swift
//  PreTest
//
//  Created by alpiopio on 15/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import UIKit

enum PageState {
    case loading
    case empty
    case error(String)
    case success
}

protocol RegisterView: class {
    func setupPage(with state: PageState)
}

class RegisterController: UIViewController {
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private lazy var viewModel: RegisterViewModel = {
        let viewModel = RegisterViewModel()
        viewModel.delegate = self
        return viewModel
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Register"
        registerKeyboardNotifications()
        register.addTarget(self, action: #selector(registerTapped(_:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc
    private func registerTapped(_ sender: UIButton) {
        viewModel.register(with: phoneNumber.text, password: password.text, country: country.text)
    }
}

// MARK: Handle keyboard on small screen
extension RegisterController {
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        var contentInsets = scrollView.contentInset
        contentInsets.bottom = keyboardSize.height
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc
    private func keyboardWillHide(notification: NSNotification) {
        var contentInsets = scrollView.contentInset
        contentInsets.bottom = 0
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}

extension RegisterController: RegisterView {
    func setupPage(with state: PageState) {
        DispatchQueue.main.async {
            self.register.isEnabled = true
            switch state {
            case .loading:
                self.register.isEnabled = false
            case .success:
                let viewModel = OTPViewModel(id: self.viewModel.getId(), phone: self.viewModel.getPhoneNumber())
                let viewController = OTPController(viewModel: viewModel)
                self.navigationController?.pushViewController(viewController, animated: true)
            case .error(let message):
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
                self.navigationController?.present(alert, animated: true, completion: nil)
            default: break
            }
        }
    }
}
