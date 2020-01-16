//
//  ProfileController.swift
//  PreTest
//
//  Created by alpiopio on 16/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import UIKit

protocol ProfileView: class {
    func setupPage(with state: PageState)
}

class ProfileController: UIViewController {
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var school: UILabel!
    @IBOutlet weak var graduation: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var end: UILabel!
    @IBOutlet weak var education: UIButton!
    @IBOutlet weak var career: UIButton!
    @IBOutlet weak var logout: UIButton!
    
    private lazy var viewModel: ProfileViewModel = {
        let viewModel = ProfileViewModel()
        viewModel.delegate = self
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(messageTapped(_:)))
        logout.addTarget(self, action: #selector(logoutTapped(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchProfile()
    }
    
    @objc
    private func messageTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @objc
    private func logoutTapped(_ sender: UIButton) {
        
    }
}

extension ProfileController: ProfileView {
    func setupPage(with state: PageState) {
        switch state {
        case .success:
            name.text = viewModel.getName()
            school.text = viewModel.getSchool()
            graduation.text = viewModel.getGraduation()
            company.text = viewModel.getCompany()
            start.text = viewModel.getStart()
            end.text = viewModel.getEnd()
            profile.downloaded(from: viewModel.getProfileURL(), contentMode: .scaleAspectFit)
            cover.downloaded(from: viewModel.getCoverURL(), contentMode: .scaleAspectFill)
        case .error(let message):
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
        default: break
        }
    }
}
