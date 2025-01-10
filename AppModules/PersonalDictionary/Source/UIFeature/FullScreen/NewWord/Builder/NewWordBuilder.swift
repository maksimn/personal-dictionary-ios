//
//  NewWordBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule
import UDF
import UIKit

/// Реализация билдера Фичи "Добавление нового слова" в личный словарь.
final class NewWordBuilder: ViewControllerBuilder {

    private let featureName = "PersonalDictionary.NewWord"

    private let bundle: Bundle
    private let langData: LangData

    /// Инициализатор.
    /// - Parameters:
    ///  - bundle: бандл приложения.
    init(bundle: Bundle, langData: LangData) {
        self.bundle = bundle
        self.langData = langData
    }

    /// Создать экран фичи
    /// - Returns:
    ///  - экран фичи  "Добавление нового слова".
    func build() -> UIViewController {
        let langRepositoryFactory = LangRepositoryFactory(
            langData: langData,
            featureName: featureName
        )
        let langRepository = langRepositoryFactory.create()

        let newWord = NewWord(
            langRepository: langRepository,
            newWordSender: NewWordStreamFactory(featureName: featureName).create()
        )

        let store = Store(
            state: NewWordState(),
            reducer: newWord.reducer
        )
        let disposable = store.onAction(with: { (state, action) in
            if isDevelopment() {
                debugPrint(Action.self, action, state)
            }
        })

        let view = NewWordViewController(
            params: viewParams(),
            store: store,
            newWord: newWord,
            langPickerBuilder: langPickerBuilder(store, allLangs: langData.allLangs),
            theme: Theme.data,
            logger: LoggerImpl(category: featureName)
        )

        view.connect(to: store)
        disposable.dispose(on: view.disposer)

        return view
    }

    private func viewParams() -> NewWordViewParams {
        NewWordViewParams(
            okText: bundle.moduleLocalizedString("LS_OK"),
            textFieldPlaceholder: bundle.moduleLocalizedString("LS_ENTER_NEW_WORD")
        )
    }

    private func langPickerBuilder(_ store: Store<NewWordState>, allLangs: [Lang]) -> ViewBuilder {
        LangPickerBuilder(
            bundle: bundle,
            allLangs: allLangs,
            store: store.scope(\.langPicker)
        )
    }
}
