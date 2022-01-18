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
        return SuperAppImpl(todoListAppBuilder: TodoListAppBuilderImpl())
    }
}
