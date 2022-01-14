//
//  SuperListAppBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 16.12.2021.
//

import TodoList

/// Реализация билдера супераппа ("основного приложения").
final class SuperAppBuilderImpl: SuperAppBuilder {

    /// Создать экземпляр супераппа.
    func build() -> SuperApp {
        return SuperAppImpl(todoListAppBuilder: buildTodoListAppBuilder())
    }

    private func buildTodoListAppBuilder() -> TodoListAppBuilder {
        let routeToPersonalDictionaryButtonTitle = NSLocalizedString("My dictionary", comment: "")
        let todoListAppParams = TodoListAppParams(
            routingButtonTitle: routeToPersonalDictionaryButtonTitle
        )

        return TodoListAppBuilderImpl(appParams: todoListAppParams)
    }
}
