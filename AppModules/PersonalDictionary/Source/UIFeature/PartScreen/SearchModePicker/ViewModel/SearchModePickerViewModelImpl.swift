//
//  SearchModeViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

import CoreModule
import RxSwift

/// Реализация модели выбора режима поиска.
final class SearchModePickerViewModelImpl: SearchModePickerViewModel {

    let searchMode = BindableSeachMode(value: .bySourceWord)

    private let searchModeSender: SearchModeSender
    private let logger: Logger
    private let disposeBag = DisposeBag()

    init(searchModeSender: SearchModeSender, logger: Logger) {
        self.searchModeSender = searchModeSender
        self.logger = logger
        subscribe()
    }

    private func subscribe() {
        searchMode.subscribe(onNext: { [weak self] in
            self?.onNext(searchMode: $0)
        }).disposed(by: disposeBag)
    }

    private func onNext(searchMode: SearchMode) {
        logger.logSending(searchMode, toModelStream: "search mode")

        searchModeSender.send(searchMode)
    }
}
