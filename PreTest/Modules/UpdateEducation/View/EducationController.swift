//
//  EducationController.swift
//  PreTest
//
//  Created by alpiopio on 16/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import UIKit

protocol EducationView: class {
    func setupPage(with state: PageState)
}

class EducationController: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var update: UIButton!
    
    private let datePicker = UIDatePicker()
    private var viewModel: EducationViewModel!
    
    init(viewModel: EducationViewModel) {
        super.init(nibName: "EducationController", bundle: nil)
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Update Education"
        update.addTarget(self, action: #selector(updateTapped(_:)), for: .touchUpInside)
        name.text = viewModel.getCurrentName()
        time.text = viewModel.getCurrentGraduation()
        time.delegate = self
    }
    
    @objc
    private func updateTapped(_ sender: UIButton) {
        viewModel.updateEducation(with: name.text, graduation: time.text)
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
        time.text = datePicker.date.toString(dateFormat: "dd-MM-yyyy")
        self.view.endEditing(true)
    }
    
    @objc
    func cancelTimePicker() {
        self.view.endEditing(true)
    }
}

extension EducationController: EducationView {
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
                self.navigationController?.present(alert, animated: true, completion: nil)
            default: break
            }
        }
    }
}

extension EducationController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        showPicker(.date, textField: textField)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
