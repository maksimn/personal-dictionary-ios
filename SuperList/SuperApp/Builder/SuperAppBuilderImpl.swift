//
//  SuperListAppBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 16.12.2021.
//

import CoreModule
import TodoList

final class SuperAppBuilderImpl: SuperAppBuilder {

    func build() -> SuperApp {
        let coreModuleParams = CoreModuleParams(
            isLoggingEnabled: true,
            urlSessionConfiguration: URLSessionConfiguration.default
        )
        let todoListAppBuilder = buildTodoListAppBuilder(coreModuleParams: coreModuleParams)

        return SuperAppImpl(coreModuleParams: coreModuleParams,
                            todoListAppBuilder: todoListAppBuilder)
    }

    private func buildTodoListAppBuilder(coreModuleParams: CoreModuleParams) -> TodoListAppBuilder {
        let routeToPersonalDictionaryButtonTitle = NSLocalizedString("My dictionary", comment: "")
        let todoListAppParams = TodoListAppParams(
            routingButtonTitle: routeToPersonalDictionaryButtonTitle,
            coreModuleParams: coreModuleParams
        )

        return TodoListAppBuilderImpl(appParams: todoListAppParams)
    }
}
