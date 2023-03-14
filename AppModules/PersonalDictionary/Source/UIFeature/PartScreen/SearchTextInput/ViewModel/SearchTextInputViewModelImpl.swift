//
//  SearchTextInputViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import CoreModule
import RxSwift

/// Реализация модели элемента ввода поискового текста.
final class SearchTextInputViewModelImpl: SearchTextInputViewModel {

    let searchText = BindableString(value: "")

    private let searchTextStream: MutableSearchTextStream
    private let logger: SLogger
    private let disposeBag = DisposeBag()

    init(searchTextStream: MutableSearchTextStream, logger: SLogger) {
        self.searchTextStream = searchTextStream
        self.logger = logger
        subscribe()
    }

    private func subscribe() {
        searchText.subscribe(onNext: { [weak self] in
            self?.onNext(searchText: $0)
        }).disposed(by: disposeBag)
    }

    private func onNext(searchText: String) {
        logger.log("Sending \"\(searchText)\" to the search text stream.")

        searchTextStream.send(searchText)
    }
}
