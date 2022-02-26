//
//  NavToSearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import UIKit

/// Реализация билдера фичи "Навигация ".
final class NavToOtherAppBuilderImpl: NavToOtherAppBuilder {

    let appParams: AppParams

    /// Инициализатор.
    /// - Parameters:
    ///  - width: параметр ширины представления.
    init(appParams: AppParams) {
        self.appParams = appParams
    }

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView {
        NavToOtherAppView(appParams: appParams)
    }
}
