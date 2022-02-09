//
//  LangPickerBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

/// Реализация билдера Фичи "Выбор языка".
final class LangPickerBuilderImpl: LangPickerBuilder {

    private let allLangs: [Lang]

    /// Инициализатор.
    /// - Parameters:
    ///  - allLangs: список всех доступных языков.
    init(allLangs: [Lang]) {
        self.allLangs = allLangs
    }

    /// Создать MVVM-граф фичи.
    /// - Returns:
    ///  - Граф фичи "Выбор языка".
    func build() -> LangPickerMVVM {
        LangPickerMVVMImpl(
            viewParams: LangPickerViewParams(
                selectButtonTitle: Bundle(for: type(of: self)).moduleLocalizedString("Select"),
                langs: allLangs,
                backgroundColor: Theme.data.backgroundColor
            )
        )
    }
}
