//
//  LangPickerBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule
import UDF
import UIKit

/// Builder of the "Language Selection" Feature.
final class LangPickerBuilder: ViewBuilder {

    private let bundle: Bundle
    private let allLangs: [Lang]
    private let store: Store<LangPickerState>

    /// Initializer.
    /// - Parameters:
    ///  - bundle: application bundle.
    ///  - allLangs: list of all available languages.
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
