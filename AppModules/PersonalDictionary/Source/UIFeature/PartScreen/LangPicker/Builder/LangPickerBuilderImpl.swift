//
//  LangPickerBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

/// Реализация билдера Фичи "Выбор языка".
final class LangPickerBuilderImpl: LangPickerBuilder {

    private let bundle: Bundle
    private let allLangs: [Lang]

    /// Инициализатор.
    /// - Parameters:
    ///  - bundle: бандл приложения.
    ///  - allLangs: список всех доступных языков.
    init(bundle: Bundle,
         allLangs: [Lang]) {
        self.bundle = bundle
        self.allLangs = allLangs
    }

    /// Создать MVVM-граф фичи.
    /// - Returns:
    ///  - Граф фичи "Выбор языка".
    func build() -> LangPickerGraph {
        let viewParams = LangPickerParams(
            title: bundle.moduleLocalizedString("LS_SELECT"),
            langs: allLangs
        )

        return LangPickerGraphImpl(viewParams: viewParams)
    }
}
