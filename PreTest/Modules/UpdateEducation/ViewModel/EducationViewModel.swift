//
//  EducationViewModel.swift
//  PreTest
//
//  Created by alpiopio on 16/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import Foundation

class EducationViewModel {
    weak var delegate: EducationView?
    
    private var name: String?
    private var graduation: String?
    
    init(name: String?, graduation: String?) {
        self.name = name
        self.graduation = graduation
    }
    
    func updateEducation(with name: String?, graduation: String?) {
        guard let name = name,
            let graduation = graduation else {
            delegate?.setupPage(with: .error("All input is required"))
            return
        }
        NetworkManager.instance.requestObject(PreTestAPI.updateEducation(name: name, graduation: graduation), c: ProfileResponse.self) { (result) in
            switch result {
            case .success:
                self.delegate?.setupPage(with: .success)
            case .failure(let error):
                self.delegate?.setupPage(with: .error(error.description))
            }
        }
    }
    
    func getCurrentName() -> String? {
        return name
    }
    
    func getCurrentGraduation() -> String? {
        return graduation?.toDate(dateFormat: "yyyy-MM-dd")?.toString(dateFormat: "dd-MM-yyyy")
    }
}
