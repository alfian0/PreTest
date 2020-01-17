//
//  CareerViewModel.swift
//  PreTest
//
//  Created by alpiopio on 16/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import Foundation

class CareerViewModel {
    private let position: String?
    private let name: String?
    private let start: String?
    private let end: String?
    
    weak var delegate: CareerView?
    
    init(position: String?, name: String?, start: String?, end: String?) {
        self.position = position
        self.name = name
        self.start = start
        self.end = end
    }
    
    func updateCareer(with position: String?, name: String?, start: String?, end: String?) {
        guard let position = position,
            let name = name,
            let start = start,
            let end = end else {
            return
        }
        self.delegate?.setupPage(with: .loading)
        NetworkManager.instance.requestObject(PreTestAPI.updateCareer(position: position, name: name, start: start, end: end), c: ProfileResponse.self) { (result) in
            switch result {
            case .success:
                self.delegate?.setupPage(with: .success)
            case .failure(let error):
                self.delegate?.setupPage(with: .error(error.description))
            }
        }
    }
    
    func getPosition() -> String? {
        return position
    }
    
    func getName() -> String? {
        return name
    }
    
    func getStart() -> String? {
        return start
    }
    
    func getEnd() -> String? {
        return end
    }
}
