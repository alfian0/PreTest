//
//  MessageController.swift
//  PreTest
//
//  Created by alpiopio on 16/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import UIKit

protocol MessageView: class {
    func setupPage(with state: PageState)
}

class MessageController: UITableViewController {
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Text me ..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        view.backgroundColor = .white
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        sendButton.addTarget(self, action: #selector(sendTapped(_:)), for: .touchUpInside)
        view.addSubview(textField)
        textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        textField.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        let separator = UIView()
        separator.backgroundColor = .systemGray4
        separator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separator)
        separator.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        separator.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    override var canBecomeFirstResponder: Bool { return true }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    private var viewModel: MessageViewModel!
    
    init(viewModel: MessageViewModel) {
        super.init(style: .plain)
        
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Message"
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
    }
    
    @objc
    private func sendTapped(_ sender: UIButton) {
        guard let text = textField.text else { return }
        viewModel.sendMessage(with: text)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.itemForRow(at: indexPath)
        return cell
    }
}

extension MessageController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension MessageController: MessageView {
    func setupPage(with state: PageState) {
        DispatchQueue.main.async {
            switch state {
            case .error(let message):
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
                alert.show()
            default:
                self.tableView.reloadData()
                self.textField.text = ""
                self.textField.resignFirstResponder()
            }
        }
    }
}
