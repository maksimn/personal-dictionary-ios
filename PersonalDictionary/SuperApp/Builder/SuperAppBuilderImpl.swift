//
//  SuperListAppBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 16.12.2021.
//

import Foundation

final class SuperAppBuilderImpl: SuperAppBuilder {

    func build() -> SuperApp {
        SuperAppImpl(routeToTodoListButtonTitle: NSLocalizedString("My todos", comment: ""),
                     routeToPersonalDictionaryButtonTitle: NSLocalizedString("My dictionary", comment: ""))
    }
}
