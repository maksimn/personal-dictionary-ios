//
//  UIViewController+Core.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 15.02.2023.
//

import UIKit

extension UIViewController {

    public func add(childViewController: UIViewController) {
        view.addSubview(childViewController.view)
        addChild(childViewController)
        childViewController.didMove(toParent: self)
    }
}
