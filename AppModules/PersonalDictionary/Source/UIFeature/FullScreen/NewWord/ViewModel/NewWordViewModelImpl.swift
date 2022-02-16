//
//  NewWordViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import RxCocoa
import RxSwift

/// Реализация модели представления для экрана добавления нового слова в личный словарь.
final class NewWordViewModelImpl: NewWordViewModel {

    private let model: NewWordModel

    /// Данные модели представления
    let state = BehaviorRelay<NewWordModelState?>(value: nil)

    /// Инициализатор.
    /// - Parameters:
    ///  - model: модель фичи "Добавление нового слова"
    init(model: NewWordModel) {
        self.model = model
    }

    /// Обновить модель представления.
    /// - Parameters:
    ///  - state: данные модели представления.
    func update(_ state: NewWordModelState) {
        self.state.accept(state)
    }

    /// Отправить событие добавления нового слова в словарь
    func sendNewWord() {
        model.sendNewWord()
    }

    /// Обновить написание слова в модели
    /// - Parameters:
    ///  - text: написание слова
    func update(text: String) {
        var state = state.value

        state?.text = text
        self.state.accept(state)
    }

    /// Обновить данные об исходном / целевом языке для слова в модели
    /// - Parameters:
    ///  - data: данные о выбранном языке.
    func update(data: LangSelectorData) {
        var state = state.value
        
        if data.selectedLangType == .source {
            state?.sourceLang = data.selectedLang
            model.save(sourceLang: data.selectedLang)
        } else {
            state?.targetLang = data.selectedLang
            model.save(targetLang: data.selectedLang)
        }

        state?.isLangPickerHidden = true
        self.state.accept(state)
    }

    /// Показать представление для выбора языка.
    /// - Parameters:
    ///  - selectedLangType: тип выбранного языка (исходный / целевой).
    func showLangPickerView(selectedLangType: SelectedLangType) {
        var state = state.value

        state?.selectedLangType = selectedLangType
        state?.isLangPickerHidden = false
        self.state.accept(state)
    }
}
