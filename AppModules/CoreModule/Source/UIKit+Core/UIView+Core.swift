//
//  UIView+Core.swift
//  CoreModule
//
//  Created by Maxim Ivanov on 07.09.2023.
//

import UIKit

extension UIView {

    public func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
