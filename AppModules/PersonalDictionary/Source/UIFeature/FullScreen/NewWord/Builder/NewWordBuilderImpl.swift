//
//  NewWordBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

/// Реализация билдера Фичи "Добавление нового слова" в личный словарь.
final class NewWordBuilderImpl: NewWordBuilder {

    private let appViewConfigs: AppViewConfigs
    private let langRepository: LangRepository

    /// Инициализатор.
    /// - Parameters:
    ///  - appViewConfigs: параметры конфигурации приложения.
    ///  - langRepository: хранилище с данными о языках в приложении.
    init(appViewConfigs: AppViewConfigs,
         langRepository: LangRepository) {
        self.appViewConfigs = appViewConfigs
        self.langRepository = langRepository
    }

    /// Создать MVVM-граф фичи
    /// - Returns:
    ///  - MVVM-граф фичи  "Добавление нового слова".
    func build() -> NewWordMVVM {
        let dependencies = NewWordDependencies(appViewConfigs: appViewConfigs,
                                               langRepository: langRepository)

        return NewWordMVVMImpl(langRepository: langRepository,
                               newWordItemStream: dependencies.newWordItemStream,
                               viewParams: dependencies.viewParams,
                               langPickerBuilder: dependencies.langPickerBuilder)
    }
}
