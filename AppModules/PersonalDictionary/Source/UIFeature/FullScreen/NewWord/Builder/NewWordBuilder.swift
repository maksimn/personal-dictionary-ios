//
//  NewWordBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule

/// Реализация билдера Фичи "Добавление нового слова" в личный словарь.
final class NewWordBuilder: ViewControllerBuilder {

    private let bundle: Bundle
    private let langRepository: LangRepository

    /// Инициализатор.
    /// - Parameters:
    ///  - bundle: бандл приложения.
    ///  - langRepository: репозиторий данных о языках в приложении.
    init(bundle: Bundle,
         langRepository: LangRepository) {
        self.bundle = bundle
        self.langRepository = langRepository
    }

    /// Создать экран фичи
    /// - Returns:
    ///  - экран фичи  "Добавление нового слова".
    func build() -> UIViewController {
        let model = NewWordModelImpl(
            langRepository: langRepository,
            newWordSender: WordStreamImpl.instance,
            logger: logger()
        )
        let viewModel = NewWordViewModelImpl(
            model: model,
            initState: initialState(),
            logger: logger()
        )
        let view = NewWordViewController(
            params: viewParams(),
            viewModel: viewModel,
            langPickerBuilder: langPickerBuilder(),
            theme: Theme.data,
            logger: logger()
        )

        return view
    }

    private func viewParams() -> NewWordViewParams {
        NewWordViewParams(
            arrowText: "⇋",
            okText: bundle.moduleLocalizedString("LS_OK"),
            textFieldPlaceholder: bundle.moduleLocalizedString("LS_ENTER_NEW_WORD")
        )
    }

    private func initialState() -> NewWordState {
        NewWordState(
            text: "",
            sourceLang: langRepository.sourceLang,
            targetLang: langRepository.targetLang,
            langPickerState: initialLangPickerState()
        )
    }

    private func langPickerBuilder() -> LangPickerBuilder {
        LangPickerBuilderImpl(
            bundle: bundle,
            allLangs: langRepository.allLangs
        )
    }

    private func initialLangPickerState() -> LangPickerState {
        LangPickerState(
            lang: langRepository.sourceLang,
            langType: .source,
            isHidden: true
        )
    }

    private func logger() -> Logger {
        LoggerImpl(category: "PersonalDictionary.NewWord")
    }
}
