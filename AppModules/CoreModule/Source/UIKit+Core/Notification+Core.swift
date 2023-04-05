//
//  Notification+Core.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 16.02.2023.
//

import UIKit

extension Notification {

    public var keyboardSize: CGSize {
        ((userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size) ?? .zero
    }
}
