//
//  LangPickerViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import RxCocoa
import RxSwift

/// Реализация модели представления Выбора языка.
final class LangPickerViewModelImpl: LangPickerViewModel {

    private let model: LangPickerModel
    private let publishRelay = PublishRelay<LangSelectorData>()

    /// Инициализатор.
    /// - Parameters:
    ///  - model: модель фичи "Выбор языка"
    init(model: LangPickerModel) {
        self.model = model
    }

    /// Данные модели представления.
    var langSelectorData: Observable<LangSelectorData> {
        publishRelay.asObservable()
    }

    /// Обновить сведения о выбранном языке.
    /// - Parameters:
    ///  - data: данные о выбранном языке.
    func updateSelectedLang(_ data: LangSelectorData) {
        publishRelay.accept(data)
    }

    /// Оповестить о выбранном языке.
    /// - Parameters:
    ///  - data: данные о выбранном языке.
    func notifyAboutSelectedLang(_ data: LangSelectorData) {
        model.listener?.onLangSelected(data)
    }
}
