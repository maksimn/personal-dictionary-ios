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

    let mainScreenState = BindableMainScreenState(value: .main)

    private let searchTextStream: MutableSearchTextStream
    private let mainScreenStateStream: MutableMainScreenStateStream
    private let logger: SLogger
    private let disposeBag = DisposeBag()

    init(
        searchTextStream: MutableSearchTextStream,
        mainScreenStateStream: MutableMainScreenStateStream,
        logger: SLogger
    ) {
        self.searchTextStream = searchTextStream
        self.mainScreenStateStream = mainScreenStateStream
        self.logger = logger
        subscribe()
    }

    private func subscribe() {
        searchText.subscribe(onNext: { [weak self] in
            self?.onNext(searchText: $0)
        }).disposed(by: disposeBag)
        mainScreenState.subscribe(onNext: { [weak self] in
            self?.onNext(mainScreenState: $0)
        }).disposed(by: disposeBag)
    }

    private func onNext(searchText: String) {
        logger.log("Sending \"\(searchText)\" to the search text stream.")

        searchTextStream.send(searchText)
    }

    private func onNext(mainScreenState: MainScreenState) {
        logger.log("Sending \"\(mainScreenState)\" to the MAIN SCREEN STATE STREAM.")

        mainScreenStateStream.send(mainScreenState)
    }
}
