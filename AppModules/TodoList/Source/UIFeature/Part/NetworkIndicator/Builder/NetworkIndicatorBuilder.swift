//
//  NetworkIndicator.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 13.08.2022.
//

import ComposableArchitecture
import UIKit

final class NetworkIndicatorBuilder: ViewBuilder {

    private let store: StoreOf<NetworkIndicator>

    init(store: StoreOf<NetworkIndicator>) {
        self.store = store
    }

    func build() -> UIView {
        NetworkIndicatorView(store: store)
    }
}
