//
//  NewWordBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

/// Внешние зависимости фичи "Добавление нового слова" в личный словарь.
protocol NewWordExternals {

    /// Параметры конфигурации представлений приложения.
    var appViewConfigs: AppViewConfigs { get }

    /// Хранилище с данными о языках в приложении.
    var langRepository: LangRepository { get }
}

/// Реализация билдера Фичи "Добавление нового слова" в личный словарь.
final class NewWordBuilderImpl: NewWordBuilder {

    private let externals: NewWordExternals

    /// Инициализатор.
    /// - Parameters:
    ///  - externals: внешние зависимости фичи.
    init(externals: NewWordExternals) {
        self.externals = externals
    }

    /// Создать MVVM-граф фичи
    /// - Returns:
    ///  - MVVM-граф фичи  "Добавление нового слова".
    func build() -> NewWordMVVM {
        let dependencies = NewWordDependencies(externals: externals)

        return NewWordMVVMImpl(
            langRepository: externals.langRepository,
            newWordItemStream: dependencies.newWordItemStream,
            viewParams: dependencies.viewParams,
            langPickerBuilder: dependencies.langPickerBuilder
        )
    }
}
