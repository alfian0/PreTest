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
    func onLogout()
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
    @IBOutlet weak var editCover: UIButton!
    @IBOutlet weak var editProfile: UIButton!
    
    private lazy var viewModel: ProfileViewModel = {
        let viewModel = ProfileViewModel()
        viewModel.delegate = self
        return viewModel
    }()
    
    private lazy var attachmentCover: AttachmentHandler = {
        let attachment = AttachmentHandler(items: [.camera, .photoLibrary])
        attachment.delegate = self
        return attachment
    }()
    
    private lazy var attachmentProfile: AttachmentHandler = {
        let attachment = AttachmentHandler(items: [.camera, .photoLibrary])
        attachment.delegate = self
        return attachment
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(messageTapped(_:)))
        logout.addTarget(self, action: #selector(logoutTapped(_:)), for: .touchUpInside)
        career.addTarget(self, action: #selector(updateCareerTapped(_:)), for: .touchUpInside)
        education.addTarget(self, action: #selector(updateEducationTapped(_:)), for: .touchUpInside)
        editCover.addTarget(self, action: #selector(coverTapped(_:)), for: .touchUpInside)
        editProfile.addTarget(self, action: #selector(profileTapped(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchProfile()
    }
    
    @objc
    private func coverTapped(_ sender: UIBarButtonItem) {
        attachmentCover.showAttachmentActionSheet(viewController: self)
    }
    
    @objc
    private func profileTapped(_ sender: UIBarButtonItem) {
        attachmentProfile.showAttachmentActionSheet(viewController: self)
    }
    
    @objc
    private func messageTapped(_ sender: UIBarButtonItem) {
        let viewModel = MessageViewModel(id: self.viewModel.getId())
        let viewController = MessageController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc
    private func updateCareerTapped(_ sender: UIButton) {
        let viewModel = CareerViewModel(position: "", name: self.viewModel.getCompany(), start: self.viewModel.getStart(), end: self.viewModel.getEnd())
        let viewController = CareerController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc
    private func updateEducationTapped(_ sender: UIButton) {
        let viewModel = EducationViewModel(name: self.viewModel.getSchool(), graduation: self.viewModel.getGraduation())
        let viewController = EducationController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc
    private func logoutTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Warning", message: "Are you sure to logout ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] (_) in
            self?.viewModel.logout()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.show()
    }
}

extension ProfileController: ProfileView {
    func onLogout() {
        DispatchQueue.main.async {
            self.navigationController?.setViewControllers([RegisterController()], animated: false)
        }
    }
    
    func setupPage(with state: PageState) {
        DispatchQueue.main.async {
            switch state {
            case .loading:
                let alert = UIAlertController(title: nil, message: "Loading ...", preferredStyle: .alert)
                alert.show()
            case .success:
                self.dismiss(animated: true) {
                    self.name.text = self.viewModel.getName()
                    self.school.text = self.viewModel.getSchool()
                    self.graduation.text = self.viewModel.getGraduation()
                    self.company.text = self.viewModel.getCompany()
                    self.start.text = self.viewModel.getStart()
                    self.end.text = self.viewModel.getEnd()
                    self.profile.downloaded(from: self.viewModel.getProfileURL(), contentMode: .scaleAspectFit)
                    self.cover.downloaded(from: self.viewModel.getCoverURL(), contentMode: .scaleAspectFill)
                }
            case .error(let message):
                self.dismiss(animated: true, completion: nil)
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
                alert.show()
            default: break
            }
        }
    }
}

extension ProfileController: AttachmentHandlerDelegate {
    func didSelectFile(with url: URL, attachment: AttachmentHandler) {
        guard let image = UIImage(contentsOfFile: url.path) else { return }
        if attachment == attachmentCover {
            cover.image = image
            viewModel.updateCover(with: image)
        } else if attachment == attachmentProfile {
            profile.image = image
            viewModel.updateProfile(with: image)
        }
    }
}
