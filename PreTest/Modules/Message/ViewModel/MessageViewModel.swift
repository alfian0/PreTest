//
//  MessageViewModel.swift
//  PreTest
//
//  Created by alpiopio on 16/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import Foundation

class MessageViewModel {
    weak var delegate: MessageView?
    private let id: String
    private var messages: [String] = []
    
    init(id: String) {
        self.id = id
    }
    
    func sendMessage(with message: String) {
        NetworkManager.instance.requestObject(PreTestAPI.message(id: id, message: message), c: SuccessResponse.self) { (result) in
            switch result {
            case .success:
                self.messages.append(message)
                self.delegate?.setupPage(with: .success)
            case .failure(let error):
                self.delegate?.setupPage(with: .error(error.description))
            }
        }
    }
    
    func numberOfRowsInSection() -> Int {
        return messages.count
    }
    
    func itemForRow(at indexPath: IndexPath) -> String {
        return messages[indexPath.row]
    }
}
