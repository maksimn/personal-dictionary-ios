//
//  SearchModeViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

/// Реализация модели представления выбора режима поиска.
final class SearchModePickerViewModelImpl: SearchModePickerViewModel {

    private weak var view: SearchModePickerView?
    private let model: SearchModePickerModel

    /// Инициализатор.
    /// - Parameters:
    ///  - model: модель фичи "Выбор режима поиска"
    ///  - view: представление фичи "Выбор режима поиска"
    init(model: SearchModePickerModel, view: SearchModePickerView) {
        self.model = model
        self.view = view
    }

    /// Режим поиска (данные модели представления).
    var searchMode: SearchMode? {
        didSet {
            guard let searchMode = searchMode else { return }
            view?.set(searchMode)
        }
    }

    /// Обновить состояние модели режима поиска.
    /// - Parameters:
    ///  - searchMode: значение режима поиска.
    func update(_ searchMode: SearchMode) {
        model.update(searchMode)
    }
}
