//
//  NewWordBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

/// Внешние зависимости фичи "Добавление нового слова" в личный словарь.
protocol NewWordDependency {

    /// Хранилище с данными о языках в приложении.
    var langRepository: LangRepository { get }
}

/// Реализация билдера Фичи "Добавление нового слова" в личный словарь.
final class NewWordBuilderImpl: NewWordBuilder {

    private let langRepository: LangRepository

    /// Инициализатор.
    /// - Parameters:
    ///  - dependency: внешние зависимости фичи.
    init(dependency: NewWordDependency) {
        langRepository = dependency.langRepository
    }

    /// Создать MVVM-граф фичи
    /// - Returns:
    ///  - MVVM-граф фичи  "Добавление нового слова".
    func build() -> NewWordMVVM {
        NewWordMVVMImpl(
            langRepository: langRepository,
            newWordItemStream: WordItemStreamImpl.instance,
            viewParams: createViewParams(),
            langPickerBuilder: LangPickerBuilderImpl(allLangs: langRepository.allLangs)
        )
    }

    private func createViewParams() -> NewWordViewParams {
        let bundle = Bundle(for: type(of: self))
        return NewWordViewParams(
            arrowText: bundle.moduleLocalizedString("⇋"),
            okText: bundle.moduleLocalizedString("OK"),
            textFieldPlaceholder: bundle.moduleLocalizedString("Enter a new word")
        )
    }
}
