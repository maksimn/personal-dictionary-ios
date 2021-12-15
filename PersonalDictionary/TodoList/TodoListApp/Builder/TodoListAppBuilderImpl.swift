//
//  TodoListAppBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 16.12.2021.
//

final class TodoListAppBuilderImpl: TodoListAppBuilder {

    private let superAppRoutingButtonTitle: String

    init(superAppRoutingButtonTitle: String) {
        self.superAppRoutingButtonTitle = superAppRoutingButtonTitle
    }

    func build() -> TodoListApp {
        TodoListAppImpl(superAppRoutingButtonTitle: superAppRoutingButtonTitle)
    }
}
