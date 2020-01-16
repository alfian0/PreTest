//
//  ProfileController.swift
//  PreTest
//
//  Created by alpiopio on 16/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import UIKit

class ProfileViewModel {
    private var id: String?
    private var name: String?
    private var school: String?
    private var graduation: String?
    private var company: String?
    private var start: String?
    private var end: String?
    private var profile: String?
    private var cover: String?
    
    weak var delegate: ProfileView?
    
    func fetchProfile() {
        NetworkManager.instance.requestObject(PreTestAPI.profile, c: ProfileResponse.self) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.id = response.data.user.id
                    self.name = response.data.user.name
                    self.school = response.data.user.education.schoolName
                    self.graduation = response.data.user.education.graduationTime
                    self.company = response.data.user.career.companyName
                    self.start = response.data.user.career.startingFrom
                    self.end = response.data.user.career.endingIn
                    self.profile = response.data.user.userPicture?.picture.url
                    self.cover = response.data.user.coverPicture.url
                    self.delegate?.setupPage(with: .success)
                case .failure(let error):
                    switch error {
                    case .authenticationError:
                        UserDefaults.standard.removeObject(forKey: Constant.userDefaults.tokenType)
                        UserDefaults.standard.removeObject(forKey: Constant.userDefaults.accessToken)
                        UserDefaults.standard.synchronize()
                        self.delegate?.onLogout()
                    default:
                        self.delegate?.setupPage(with: .error(error.description))
                    }
                }
            }
        }
    }
    
    func updateCover(with image: UIImage) {
        guard let media = Media(withImage: image, forKey: "image") else { return }
        delegate?.setupPage(with: .loading)
        NetworkManager.instance.requestObject(PreTestAPI.updateCover(image: media), c: CoverResponse.self) { (result) in
            switch result {
            case .success(let response):
                self.cover = response.data.userPicture.coverPicture.url
                self.delegate?.setupPage(with: .success)
            case .failure(let error):
                self.delegate?.setupPage(with: .error(error.description))
            }
        }
    }
    
    func updateProfile(with image: UIImage) {
        guard let media = Media(withImage: image, forKey: "image") else { return }
        delegate?.setupPage(with: .loading)
        NetworkManager.instance.requestObject(PreTestAPI.updateProfile(image: media), c: PhotoResponse.self) { (result) in
            switch result {
            case .success(let response):
                self.profile = response.data.userPicture.picture.url
                if let id = response.data.userPicture.id {
                    self.setDefault(with: id)
                } else {
                    self.delegate?.setupPage(with: .success)
                }
            case .failure(let error):
                self.delegate?.setupPage(with: .error(error.description))
            }
        }
    }
    
    func setDefault(with id: String) {
        NetworkManager.instance.requestObject(PreTestAPI.setDefault(id: id), c: SuccessResponse.self) { (result) in
            switch result {
            case .success:
                self.delegate?.setupPage(with: .success)
            case .failure(let error):
                self.delegate?.setupPage(with: .error(error.description))
            }
        }
    }
    
    func logout() {
        NetworkManager.instance.requestObject(PreTestAPI.logout, c: LogoutResponse.self) { (result) in
            self.resetUserData()
            self.delegate?.onLogout()
        }
    }
    
    func resetUserData() {
        UserDefaults.standard.removeObject(forKey: Constant.userDefaults.tokenType)
        UserDefaults.standard.removeObject(forKey: Constant.userDefaults.accessToken)
        UserDefaults.standard.synchronize()
    }
    
    func getId() -> String {
        return id ?? "-"
    }
    
    func getName() -> String {
        return name ?? "-"
    }
    
    func getSchool() -> String {
        return school ?? "-"
    }
    
    func getGraduation() -> String {
        return graduation ?? "-"
    }
    
    func getCompany() -> String {
        return company ?? "-"
    }
    
    func getStart() -> String {
        return start ?? "-"
    }
    
    func getEnd() -> String {
        return end ?? "-"
    }
    
    func getProfileURL() -> String {
        return profile ?? ""
    }
    
    func getCoverURL() -> String {
        return cover ?? ""
    }
}
