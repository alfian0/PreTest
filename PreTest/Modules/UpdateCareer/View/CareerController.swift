//
//  CareerController.swift
//  PreTest
//
//  Created by alpiopio on 16/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import UIKit

protocol CareerView: class {
    func setupPage(with state: PageState)
}

class CareerController: UIViewController {
    @IBOutlet weak var position: UITextField!
    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var startFrom: UITextField!
    @IBOutlet weak var endingIn: UITextField!
    @IBOutlet weak var update: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private let datePicker = UIDatePicker()
    private var viewModel: CareerViewModel!
    private var currentActiveTextField: UITextField?
    
    init(viewModel: CareerViewModel) {
        super.init(nibName: "CareerController", bundle: nil)
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

        title = "Update Career"
        registerKeyboardNotifications()
        update.addTarget(self, action: #selector(updateTapped(_:)), for: .touchUpInside)
        position.text = viewModel.getPosition()
        companyName.text = viewModel.getName()
        startFrom.text = viewModel.getStart()
        endingIn.text = viewModel.getEnd()
        startFrom.delegate = self
        endingIn.delegate = self
    }
    
    @objc
    private func updateTapped(_ sender: UIButton) {
        viewModel.updateCareer(with: position.text, name: companyName.text, start: startFrom.text, end: endingIn.text)
    }
    
    private func showPicker(_ type: UIDatePicker.Mode, textField: UITextField) {
        datePicker.calendar = Calendar(identifier: .gregorian)
        datePicker.datePickerMode = type
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTimePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTimePicker))
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        textField.inputAccessoryView = toolbar
        textField.inputView = datePicker
    }
    
    @objc
    func doneTimePicker(_ sender: UIBarButtonItem) {
        currentActiveTextField?.text = datePicker.date.toString(dateFormat: "dd-MM-yyyy")
        self.view.endEditing(true)
    }
    
    @objc
    func cancelTimePicker() {
        self.view.endEditing(true)
    }
}

// MARK: Handle keyboard on small screen
extension CareerController {
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

extension CareerController: CareerView {
    func setupPage(with state: PageState) {
        DispatchQueue.main.async {
            switch state {
            case .loading:
                self.update.isEnabled = false
            case .success:
                self.update.isEnabled = true
                self.navigationController?.popViewController(animated: true)
            case .error(let message):
                self.update.isEnabled = true
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
                alert.show()
            default: break
            }
        }
    }
}


extension CareerController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentActiveTextField = textField
        showPicker(.date, textField: textField)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
