//
//  LangPickerBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule
import UDF
import UIKit

/// Билдер Фичи "Выбор языка".
final class LangPickerBuilder: ViewBuilder {

    private let bundle: Bundle
    private let allLangs: [Lang]
    private let store: Store<LangPickerState>

    /// Инициализатор.
    /// - Parameters:
    ///  - bundle: бандл приложения.
    ///  - allLangs: список всех доступных языков.
    init(bundle: Bundle, allLangs: [Lang], store: Store<LangPickerState>) {
        self.bundle = bundle
        self.allLangs = allLangs
        self.store = store
    }

    func build() -> UIView {
        let viewParams = LangPickerParams(
            title: bundle.moduleLocalizedString("LS_SELECT"),
            langs: allLangs
        )
        let view = LangPickerView(
            params: viewParams,
            store: store,
            theme: Theme.data,
            logger: LoggerImpl(category: "PersonalDictionary.LangPicker")
        )
        
        view.connect(to: store)

        return view
    }
}
