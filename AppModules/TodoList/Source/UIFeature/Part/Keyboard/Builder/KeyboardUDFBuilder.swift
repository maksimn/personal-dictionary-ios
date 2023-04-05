//
//  KeyboardUDFBuilder.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 15.02.2023.
//

import ComposableArchitecture
import UIKit

final class KeyboardUDFBuilder: ViewControllerBuilder {

    private let store: StoreOf<KeyboardUDF>

    init(store: StoreOf<KeyboardUDF>) {
        self.store = store
    }

    func build() -> UIViewController {
        return KeyboardUDFController(
            store: store,
            notificationCenter: NotificationCenter.default
        )
    }
}
