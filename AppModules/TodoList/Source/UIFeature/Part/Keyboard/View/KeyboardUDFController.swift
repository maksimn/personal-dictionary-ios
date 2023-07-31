//
//  KeyboardUDF.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 15.02.2023.
//

import ComposableArchitecture
import UIKit

final class KeyboardUDFController: UIViewController {

    private let store: StoreOf<KeyboardUDF>
    private let notificationCenter: NotificationCenter

    init(store: StoreOf<KeyboardUDF>, notificationCenter: NotificationCenter) {
        self.store = store
        self.notificationCenter = notificationCenter
        super.init(nibName: nil, bundle: nil)
        subscribeToKeyboardEvents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sendChangeOrientationAction()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.sendChangeOrientationAction()
        })
    }

    private func subscribeToKeyboardEvents() {
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillShow(notification:)),
                                       name: UIResponder.keyboardWillShowNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillHide(notification:)),
                                       name: UIResponder.keyboardWillHideNotification,
                                       object: nil)
    }

    @objc
    private func keyboardWillShow(notification: Notification) {
        store.send(.show(notification.keyboardSize))
    }

    @objc
    private func keyboardWillHide(notification: Notification) {
        store.send(.hide)
    }

    private func sendChangeOrientationAction() {
        let sysOrientation = UIDevice.current.orientation
        let orientation: KeyboardUDF.Orientation = sysOrientation == .landscapeLeft ||
                                                   sysOrientation == .landscapeRight ? .landscape : .portrait

        store.send(.changeOrientation(orientation))
    }
}
