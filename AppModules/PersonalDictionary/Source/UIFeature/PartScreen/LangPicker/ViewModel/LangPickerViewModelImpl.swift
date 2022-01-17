//
//  LangPickerViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

/// Реализация модели представления Выбора языка.
final class LangPickerViewModelImpl: LangPickerViewModel {

    private weak var view: LangPickerView?
    private let model: LangPickerModel

    /// Инициализатор.
    /// - Parameters:
    ///  - model: модель фичи "Выбор языка"
    ///  - view: представление фичи "Выбор языка"
    init(model: LangPickerModel, view: LangPickerView) {
        self.model = model
        self.view = view
    }

    /// Данные модели представления.
    var langSelectorData: LangSelectorData? {
        didSet {
            guard let data = langSelectorData else { return }
            view?.set(langSelectorData: data)
        }
    }

    /// Отправить сведения о выбранном языке.
    /// - Parameters:
    ///  - lang: выбранный язык.
    func sendSelectedLang(_ lang: Lang) {
        model.sendSelectedLang(lang)
    }
}
