//
//  NewWordDependencies.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 04.12.2021.
//

import Foundation

/// Зависимости фичи "Добавление нового слова" в личный словарь.
final class NewWordDependencies {

    /// Параметры представления фичи "Добавление нового слова"
    let viewParams: NewWordViewParams

    /// Билдер вложенной фичи "Выбор языка"
    let langPickerBuilder: LangPickerBuilder

    /// Поток для отправки событий добавления нового слова в словарь
    let newWordItemStream: NewWordItemStream

    /// Инициализатор.
    /// - Parameters:
    ///  - externals: внешние зависимости фичи.
    init(externals: NewWordExternals) {
        let bundle = Bundle(for: type(of: self))

        viewParams = NewWordViewParams(
            arrowText: bundle.moduleLocalizedString("⇋"),
            okText: bundle.moduleLocalizedString("OK"),
            textFieldPlaceholder: bundle.moduleLocalizedString("Enter a new word"),
            backgroundColor: Theme.data.backgroundColor
        )

        langPickerBuilder = LangPickerBuilderImpl(allLangs: externals.langRepository.allLangs)
        newWordItemStream = WordItemStreamImpl.instance
    }
}
