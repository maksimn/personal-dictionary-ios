//
//  NavToSearchBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import UIKit

/// Билдер фичи "Навигация к приложению Список дел (TodoList)".
protocol NavToTodoListAppBuilder {

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView
}
