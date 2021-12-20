//
//  KeyboardEventsHandler.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 23.06.2021.
//

import UIKit

class KeyboardEventsHandle {

    var onKeyboardWillShow: ((CGSize) -> Void)?
    var onKeyboardWillHide: ((CGSize) -> Void)?

    init() { }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = keyboardSize(from: notification) {
            onKeyboardWillShow?(keyboardSize)
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = keyboardSize(from: notification) {
            onKeyboardWillHide?(keyboardSize)
        }
    }

    func keyboardSize(from notification: Notification) -> CGSize? {
        (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
    }
}
