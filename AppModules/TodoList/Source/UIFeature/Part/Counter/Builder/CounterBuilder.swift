//
//  CounterBuilder.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import ComposableArchitecture
import CoreModule
import UIKit

typealias CompletedTodoCount = Int
typealias CounterStore = Store<CompletedTodoCount, Never>

final class CounterBuilder: ViewBuilder {

    private let store: CounterStore

    init(store: CounterStore) {
        self.store = store
    }

    func build() -> UIView {
        let bundle = Bundle.module
        let template = bundle.moduleLocalizedString("LS_COMPLETED")
        let view = CounterView(template: template, store: store, theme: Theme.data)

        return view
    }
}
