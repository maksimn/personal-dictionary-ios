//
//  UIViewController+Core.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 16.12.2021.
//

import UIKit

extension UIViewController {

    func add(childViewController: UIViewController) {
        view.addSubview(childViewController.view)
        addChild(childViewController)
        childViewController.didMove(toParent: self)
    }

    func removeFromParentViewController() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
