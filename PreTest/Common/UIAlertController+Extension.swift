//
//  UIAlertController+Extension.swift
//  PreTest
//
//  Created by alpiopio on 16/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import UIKit

extension UIAlertController {
    func show() {
        present(animated: true, completion: nil)
    }
    
    func present(animated: Bool, completion: (() -> Void)?) {
        guard let root = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController else {
            return
        }
        present(with: root, animated: animated, completion: completion)
    }
    
    private func present(with viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let navigationController = viewController as? UINavigationController, let visibleViewController = navigationController.visibleViewController {
            guard let presentedViewController = visibleViewController.presentedViewController else {
                present(with: visibleViewController, animated: animated, completion: completion)
                return
            }
            present(with: presentedViewController, animated: animated, completion: completion)
        } else if let tabBarController = viewController as? UITabBarController, let selectedViewController = tabBarController.selectedViewController {
            present(with: selectedViewController, animated: animated, completion: completion)
        } else {
            viewController.present(self, animated: true, completion: nil)
        }
    }
}
