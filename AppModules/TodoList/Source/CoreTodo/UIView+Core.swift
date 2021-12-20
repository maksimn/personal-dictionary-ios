//
//  UIView+Core.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 11.06.2021.
//

import UIKit

extension UIView {

    func constraints(_ top: (anchor: NSLayoutYAxisAnchor?, value: CGFloat),
                     _ height: CGFloat?,
                     _ leading: (anchor: NSLayoutXAxisAnchor?, value: CGFloat),
                     _ trailing: (anchor: NSLayoutXAxisAnchor?, value: CGFloat)) {
        translatesAutoresizingMaskIntoConstraints = false
        if let topAnchor = top.anchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: top.value).isActive = true
        }
        if let leadingAnchor = leading.anchor {
            self.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leading.value).isActive = true
        }
        if let trailingAnchor = trailing.anchor {
            self.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailing.value).isActive = true
        }
        self.heightAnchor.constraint(equalToConstant: height ?? 0).isActive = true
    }
}
