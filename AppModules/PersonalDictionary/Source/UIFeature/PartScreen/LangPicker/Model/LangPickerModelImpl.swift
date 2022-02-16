//
//  LangPickerModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

/// Реализация модели выбора языка.
final class LangPickerModelImpl: LangPickerModel {

    /// Начальные данные о выбранном языке.
    var initData: LangSelectorData? {
        didSet {
            guard let data = initData else { return }
            viewModel?.langSelectorData.accept(data)
        }
    }

    /// Модель представления Выбора языка.
    weak var viewModel: LangPickerViewModel?

    /// Делегат события выбора языка.
    weak var listener: LangPickerListener?
}
