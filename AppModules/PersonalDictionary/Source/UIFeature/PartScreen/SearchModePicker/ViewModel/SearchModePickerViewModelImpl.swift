//
//  SearchModeViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

import RxCocoa
import RxSwift

/// Реализация модели представления выбора режима поиска.
final class SearchModePickerViewModelImpl: SearchModePickerViewModel {

    private let model: SearchModePickerModel
    private let searchModePublishRelay = PublishRelay<SearchMode>()

    /// Инициализатор.
    /// - Parameters:
    ///  - model: модель фичи "Выбор режима поиска"
    init(model: SearchModePickerModel) {
        self.model = model
    }

    /// Режим поиска (данные модели представления).
    var searchMode: Observable<SearchMode> {
        searchModePublishRelay.asObservable()
    }

    /// Обновить состояние режима поиска.
    /// - Parameters:
    ///  - searchMode: значение режима поиска.
    func update(_ searchMode: SearchMode) {
        searchModePublishRelay.accept(searchMode)
    }
}
