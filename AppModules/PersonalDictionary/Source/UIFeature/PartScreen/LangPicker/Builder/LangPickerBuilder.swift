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
        var setter: LangPickerStateSetter? = nil
        
        let udf = LangPickerUDFImpl(
            store: store,
            setterBlock: { setter },
            logger: logger()
        )
        let viewParams = LangPickerParams(
            title: bundle.moduleLocalizedString("LS_SELECT"),
            langs: allLangs
        )
        let view = LangPickerView(
            params: viewParams,
            udf: udf,
            theme: Theme.data,
            logger: logger()
        )
        
        setter = view

        return view
    }
    
    private func logger() -> Logger {
        LoggerImpl(category: "PersonalDictionary.LangPicker")
    }
}
