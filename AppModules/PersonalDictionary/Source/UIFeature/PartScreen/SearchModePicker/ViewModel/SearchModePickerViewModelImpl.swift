//
//  SearchModeViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

/// Реализация модели представления выбора режима поиска.
final class SearchModePickerViewModelImpl: SearchModePickerViewModel {

    private let model: SearchModePickerModel

    /// Инициализатор.
    /// - Parameters:
    ///  - model: модель фичи "Выбор режима поиска"
    init(model: SearchModePickerModel) {
        self.model = model
    }

    /// Режим поиска (данные модели представления).
    private(set) var searchMode: SearchMode? {
        didSet {
            searchModeChanged?()
        }
    }

    /// Для подписки view на изменения данных МП.
    var searchModeChanged: (() -> Void)?

    /// Задать в модель представления данные из модели.
    func setModelData() {
        searchMode = model.searchMode
    }

    /// Обновить состояние модели режима поиска.
    /// - Parameters:
    ///  - searchMode: значение режима поиска.
    func update(_ searchMode: SearchMode) {
        model.update(searchMode)
    }
}
