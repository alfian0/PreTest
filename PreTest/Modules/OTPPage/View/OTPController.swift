//
//  OTPController.swift
//  PreTest
//
//  Created by alpiopio on 15/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import UIKit

protocol OTPView: class {
    func setupPage(with state: PageState)
}

class OTPController: UIViewController {
    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var second: UITextField!
    @IBOutlet weak var third: UITextField!
    @IBOutlet weak var fourth: UITextField!
    @IBOutlet weak var verification: UIButton!
    @IBOutlet weak var resend: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var viewModel: OTPViewModel!
    
    init(viewModel: OTPViewModel) {
        super.init(nibName: "OTPController", bundle: nil)
        
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "OTP Verification"
        verification.addTarget(self, action: #selector(verificationTapped(_:)), for: .touchUpInside)
        resend.addTarget(self, action: #selector(resendTapped(_:)), for: .touchUpInside)
        first.delegate = self
        second.delegate = self
        third.delegate = self
        fourth.delegate = self
        registerKeyboardNotifications()
    }
    
    @objc
    private func resendTapped(_ sender: UIButton) {
        viewModel.requestOTP()
    }
    
    @objc
    private func verificationTapped(_ sender: UIButton) {
        guard let first = first.text,
            let second = second.text,
            let third = third.text,
            let fourth = fourth.text else { return }
        viewModel.verificationOTP(with: first + second + third + fourth)
    }
}

extension OTPController: OTPView {
    func setupPage(with state: PageState) {
        DispatchQueue.main.async {
            switch state {
            case .loading:
                self.verification.isEnabled = false
                self.resend.isEnabled = false
            case .success:
                self.verification.isEnabled = true
                self.resend.isEnabled = true
                self.navigationController?.setViewControllers([ProfileController()], animated: false)
            case .error(let message):
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
                self.navigationController?.present(alert, animated: true, completion: nil)
            default: break
            }
        }
    }
}

extension OTPController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = ((textField.text)! as NSString).replacingCharacters(in: range, with: string)
        let newLength = newString.count
        if newLength == 1 {
            let nextTag: Int = textField.tag + 1
            let nextResponder: UIResponder? = view.viewWithTag(nextTag)
            textField.text = newString
            if let nextR = nextResponder {
                nextR.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextResponder = view.viewWithTag(textField.tag + 1) as? UITextField {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: Handle keyboard on small screen
extension OTPController {
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
