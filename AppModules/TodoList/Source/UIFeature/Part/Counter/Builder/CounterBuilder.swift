//
//  CounterBuilder.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import ComposableArchitecture
import UIKit

typealias CompletedTodoCount = Int
typealias CounterStore = Store<CompletedTodoCount, Never>
typealias CounterViewStore = ViewStore<CompletedTodoCount, Never>

final class CounterBuilder: ViewBuilder {

    private let store: CounterStore

    init(store: CounterStore) {
        self.store = store
    }

    func build() -> UIView {
        let template = NSLocalizedString("LS_COMPLETED", comment: "")
        let view = CounterView(template: template, store: store, theme: Theme.data)

        return view
    }
}
