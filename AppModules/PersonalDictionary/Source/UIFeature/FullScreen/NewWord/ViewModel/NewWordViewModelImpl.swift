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
    private let publishRelay = PublishRelay<NewWordModelState>()

    /// Инициализатор.
    /// - Parameters:
    ///  - model: модель фичи "Добавление нового слова"
    init(model: NewWordModel) {
        self.model = model
    }

    /// Данные модели представления
    var state: Observable<NewWordModelState> {
        publishRelay.asObservable()
    }

    /// Обновить модель представления.
    /// - Parameters:
    ///  - state: данные модели представления.
    func update(_ state: NewWordModelState) {
        publishRelay.accept(state)
    }

    /// Отправить событие добавления нового слова в словарь
    func sendNewWord() {
        model.sendNewWord()
    }

    /// Обновить написание слова в модели
    /// - Parameters:
    ///  - text: написание слова
    func update(text: String) {
        model.update(text: text)
    }

    /// Обновить данные об исходном / целевом языке для слова в модели
    /// - Parameters:
    ///  - data: данные о выбранном языке.
    func update(data: LangSelectorData) {
        model.update(data: data)
    }

    /// Показать представление для выбора языка.
    /// - Parameters:
    ///  - selectedLangType: тип выбранного языка (исходный / целевой).
    func showLangPickerView(selectedLangType: SelectedLangType) {
        model.showLangPicker(selectedLangType: selectedLangType)
    }
}
