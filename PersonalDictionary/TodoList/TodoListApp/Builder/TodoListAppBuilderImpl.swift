//
//  TodoListAppBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 16.12.2021.
//

final class TodoListAppBuilderImpl: TodoListAppBuilder {

    private let routingButtonTitle: String

    init(routingButtonTitle: String) {
        self.routingButtonTitle = routingButtonTitle
    }

    func build() -> TodoListApp {
        TodoListAppImpl(routingButtonTitle: routingButtonTitle)
    }
}
