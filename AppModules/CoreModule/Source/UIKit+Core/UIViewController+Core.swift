//
//  UIViewController+Core.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 16.12.2021.
//

import UIKit

@nonobjc
extension UIViewController {

    public func add(childViewController: UIViewController) {
        view.addSubview(childViewController.view)
        addChild(childViewController)
        childViewController.didMove(toParent: self)
    }

    public func removeFromParentViewController() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

public protocol ObservationLoopLegacy: AnyObject {

    func startObservationLoop(_ updater: @escaping () -> Void)
}

extension ObservationLoopLegacy {

    public func startObservationLoop(_ updater: @escaping () -> Void) {
        withObservationTracking {
            updater()
        } onChange: { [weak self] in
            Task { @MainActor [weak self] in
                self?.startObservationLoop(updater)
            }
        }
    }
}
