//
//  NewWordBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

/// Реализация билдера Фичи "Добавление нового слова" в личный словарь.
final class NewWordBuilderImpl: NewWordBuilder {

    private let langRepository: LangRepository

    /// Инициализатор.
    /// - Parameters:
    ///  - langRepository: репозиторий данных о языках в приложении.
    init(langRepository: LangRepository) {
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
            langPickerBuilder: LangPickerBuilderImpl(allLangs: langRepository.allLangs)
        )

        viewModelLazy = viewModel

        return view
    }

    private var viewParams: NewWordViewParams {
        let bundle = Bundle(for: type(of: self))

        return NewWordViewParams(
            arrowText: bundle.moduleLocalizedString("⇋"),
            okText: bundle.moduleLocalizedString("OK"),
            textFieldPlaceholder: bundle.moduleLocalizedString("Enter a new word")
        )
    }
}
