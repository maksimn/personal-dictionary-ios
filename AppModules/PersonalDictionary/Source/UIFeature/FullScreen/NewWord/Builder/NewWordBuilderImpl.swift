//
//  NewWordBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

/// Реализация билдера Фичи "Добавление нового слова" в личный словарь.
final class NewWordBuilderImpl: NewWordBuilder {

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
        let initState = NewWordState(
            text: "",
            sourceLang: langRepository.sourceLang,
            targetLang: langRepository.targetLang,
            selectedLangType: .source,
            isLangPickerHidden: true
        )

        weak var viewModelLazy: NewWordViewModel?

        let model = NewWordModelImpl(
            viewModelBlock: { viewModelLazy },
            langRepository: langRepository,
            newWordItemStream: WordItemStreamImpl.instance
        )
        let viewModel = NewWordViewModelImpl(
            model: model,
            initState: initState
        )
        let view = NewWordViewController(
            params: viewParams,
            viewModel: viewModel,
            langPickerBuilder: LangPickerBuilderImpl(
                bundle: bundle,
                allLangs: langRepository.allLangs
            )
        )

        viewModelLazy = viewModel

        return view
    }

    private var viewParams: NewWordViewParams {
        NewWordViewParams(
            arrowText: bundle.moduleLocalizedString("⇋"),
            okText: bundle.moduleLocalizedString("OK"),
            textFieldPlaceholder: bundle.moduleLocalizedString("Enter a new word")
        )
    }
}
