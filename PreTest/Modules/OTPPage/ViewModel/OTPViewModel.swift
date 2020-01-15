//
//  OTPViewModel.swift
//  PreTest
//
//  Created by alpiopio on 16/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import Foundation

class OTPViewModel {
    weak var delegate: OTPView?
    private let phone: String!
    private var id: String?
    
    init(phone: String) {
        self.phone = phone
    }
    
    func requestOTP() {
        let router = PreTestAPI.otpRequest(phone: phone)
        NetworkManager.instance.requestObject(router, c: RegisterResponse.self) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                self.id = response.data.user.id
            case .failure(let error):
                self.delegate?.setupPage(with: .error(error.description))
            }
        }
    }
    
    func verificationOTP(with code: String) {
        self.delegate?.setupPage(with: .loading)
        let router = PreTestAPI.otpMatch(userId: id ?? "", otpCode: code)
        NetworkManager.instance.requestObject(router, c: LoginResponse.self) { (result) in
            switch result {
            case .success(let response):
                UserDefaults.standard.set(response.data.user.accessToken, forKey: Constant.userDefaults.accessToken)
                UserDefaults.standard.set(response.data.user.tokenType, forKey: Constant.userDefaults.tokenType)
                UserDefaults.standard.synchronize()
                self.delegate?.setupPage(with: .success)
            case .failure(let error):
                self.delegate?.setupPage(with: .error(error.description))
            }
        }
    }
}
