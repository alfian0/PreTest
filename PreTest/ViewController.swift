//
//  ViewController.swift
//  PreTest
//
//  Created by alpiopio on 15/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.instance.requestObject(PreTestAPI.register(phone: "088888880", password: "123456", country: "indonesia", latlong: "1234567890", deviceToken: "1234567", deviceType: 0), c: RegisterResponse.self) { (result) in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error.description)
            }
        }
    }


}

