//
//  SearchModeViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

import RxSwift
import RxCocoa

/// Реализация модели представления выбора режима поиска.
final class SearchModePickerViewModelImpl: SearchModePickerViewModel {

    /// Режим поиска (данные модели представления).
    let searchMode: BindableSearchMode

    private let model: SearchModePickerModel

    private let disposeBag = DisposeBag()

    /// Инициализатор.
    /// - Parameters:
    ///  - model: модель фичи "Выбор режима поиска"
    init(model: SearchModePickerModel,
         searchMode: SearchMode) {
        self.model = model
        self.searchMode = BindableSearchMode(value: searchMode)
        self.searchMode.subscribe(onNext: { [weak self] mode in
            self?.model.listener?.onSearchModeChanged(mode)
        }).disposed(by: disposeBag)
    }
}
