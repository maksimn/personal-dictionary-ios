//
//  NewWordViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

/// Реализация модели представления для экрана добавления нового слова в личный словарь.
final class NewWordViewModelImpl: NewWordViewModel {

    private weak var view: NewWordView?
    private let model: NewWordModel

    /// Инициализатор.
    /// - Parameters:
    ///  - model: модель фичи "Добавление нового слова"
    ///  - view: представление фичи "Добавление нового слова"
    init(model: NewWordModel, view: NewWordView) {
        self.model = model
        self.view = view
    }

    /// Данные модели представления
    var state: NewWordModelState? {
        didSet {
            view?.set(state: state)
        }
    }

    /// Отправить событие добавления нового слова в словарь
    func sendNewWord() {
        model.sendNewWord()
    }

    /// Обновить написание слова в модели
    /// - Parameters:
    ///  - text: написание слова
    func updateModel(text: String) {
        model.update(text: text)
    }

    /// Обновить данные об исходном / целевом языке для слова в модели
    /// - Parameters:
    ///  - data: данные о выбранном языке.
    func updateModel(data: LangSelectorData) {
        model.update(data: data)
    }
}
