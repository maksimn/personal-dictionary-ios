//
//  SearchModeModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

import RxSwift

/// Реализация модели выбора режима поиска.
final class SearchModePickerModelImpl: SearchModePickerModel {

    /// Модель представления выбора режима поиска.
    weak var viewModel: SearchModePickerViewModel? {
        didSet {
            subscribeToViewModel()
        }
    }

    /// Делегат фичи "Выбор режима поиска".
    weak var listener: SearchModePickerListener?

    /// Режим поиска (стейт)
    private(set) var searchMode: SearchMode

    private let disposeBag = DisposeBag()

    /// Инициализатор.
    /// - Parameters:
    ///  - searchMode: начальное значение режима поиска.
    init(searchMode: SearchMode) {
        self.searchMode = searchMode
    }

    private func subscribeToViewModel() {
        viewModel?.searchMode.subscribe(onNext: { [weak self] searchMode in
            self?.searchMode = searchMode
            self?.listener?.onSearchModeChanged(searchMode)
        }).disposed(by: disposeBag)
    }
}
