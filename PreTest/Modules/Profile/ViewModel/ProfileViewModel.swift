//
//  ProfileController.swift
//  PreTest
//
//  Created by alpiopio on 16/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import Foundation

class ProfileViewModel {
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
        delegate?.setupPage(with: .loading)
        NetworkManager.instance.requestObject(PreTestAPI.profile, c: ProfileResponse.self) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
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
                    self.delegate?.setupPage(with: .error(error.description))
                }
            }
        }
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
