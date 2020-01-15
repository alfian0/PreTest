//
//  RegisterViewModel.swift
//  PreTest
//
//  Created by alpiopio on 15/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import Foundation

class RegisterViewModel {
    weak var delegate: RegisterView?
    private var phone: String?
    
    func register(with phone: String?, password: String?, country: String?) {
        guard let phoneNumber = phone,
            let password = password,
            let country = country else {
            delegate?.setupPage(with: .error("All input is required"))
            return
        }
        self.delegate?.setupPage(with: .loading)
        let router = PreTestAPI.register(phone: phoneNumber,
                                         password: password,
                                         country: country,
                                         latlong: "set up later",
                                         deviceToken: "set up later",
                                         deviceType: 0)
        NetworkManager.instance.requestObject(router, c: RegisterResponse.self) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                self.phone = response.data.user.phone
                self.delegate?.setupPage(with: .success)
            case .failure(let error):
                self.delegate?.setupPage(with: .error(error.description))
            }
        }
    }
    
    func getPhoneNumber() -> String {
        return phone ?? ""
    }
}