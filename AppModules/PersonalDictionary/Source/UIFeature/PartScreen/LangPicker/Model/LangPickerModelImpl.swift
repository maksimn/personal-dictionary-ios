//
//  LangPickerModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import Foundation

/// Реализация модели выбора языка.
final class LangPickerModelImpl: LangPickerModel {

    /// Данные о выбранном языке ("стейт").
    var data: LangSelectorData? {
        didSet {
            viewModel?.langSelectorData = data
        }
    }

    /// Модель представления Выбора языка.
    weak var viewModel: LangPickerViewModel?

    /// Делегат события выбора языка.
    weak var listener: LangPickerListener?

    /// Отправить сведения о выбранном языке.
    /// - Parameters:
    ///  - lang: выбранный язык.
    func sendSelectedLang(_ lang: Lang) {
        guard let langType = data?.selectedLangType else { return }

        listener?.onLangSelected(LangSelectorData(selectedLang: lang,
                                                  selectedLangType: langType))
    }
}
