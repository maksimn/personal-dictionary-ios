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

    private let searchModeStream: MutableSearchModeStream
    private let logger: Logger
    private let disposeBag = DisposeBag()

    init(searchModeStream: MutableSearchModeStream, logger: Logger) {
        self.searchModeStream = searchModeStream
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

        searchModeStream.send(searchMode)
    }
}
