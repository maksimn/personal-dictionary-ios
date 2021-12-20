//
//  KeyboardEventsHandler.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 23.06.2021.
//

import UIKit

public class KeyboardEventsHandle {

    public var onKeyboardWillShow: ((CGSize) -> Void)?
    public var onKeyboardWillHide: ((CGSize) -> Void)?

    public init() {
    }

    public func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    public func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = keyboardSize(from: notification) {
            onKeyboardWillShow?(keyboardSize)
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        if let keyboardSize = keyboardSize(from: notification) {
            onKeyboardWillHide?(keyboardSize)
        }
    }

    private func keyboardSize(from notification: Notification) -> CGSize? {
        (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
    }
}
