//
//  LoginVIewModel.swift
//  PreTest
//
//  Created by alpiopio on 16/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import Foundation
import CoreLocation

class LoginViewModel {
    weak var delegate: LoginView?
    private var coordinate: CLLocation?

    func login(phone: String?, password: String?){
        guard let phone = phone,
            let password = password else {
            return
        }
        NetworkManager.instance.requestObject(PreTestAPI.login(phone: phone, password: password, latlong: getCoordinate(), deviceToken: "Setup Later"), c: LoginResponse.self) { (result) in
            switch result {
            case .success(let response):
                UserDefaults.standard.set(response.data.user.tokenType, forKey: Constant.userDefaults.tokenType)
                UserDefaults.standard.set(response.data.user.accessToken, forKey: Constant.userDefaults.accessToken)
                UserDefaults.standard.synchronize()
                self.delegate?.setupPage(with: .success)
            case .failure(let error):
                self.delegate?.setupPage(with: .error(error.description))
            }
        }
    }
    
    func setCoordinate(with coordinate: CLLocation) {
        self.coordinate = coordinate
    }
    
    func getCoordinate() -> String {
        guard let coordinate = self.coordinate else { return "" }
        return "\(coordinate.coordinate.latitude),\(coordinate.coordinate.longitude)"
    }
}
