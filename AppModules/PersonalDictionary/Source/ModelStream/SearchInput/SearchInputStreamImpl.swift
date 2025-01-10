//
//  SearchInputStreamImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 26.12.2022.
//

import RxSwift
import RxCocoa

final class SearchTextStreamImpl: SearchTextStream, SearchTextSender {

    private let relay = BehaviorRelay(value: "")

    static let instance = SearchTextStreamImpl()

    private init() { }

    var searchText: Observable<String> {
        relay.asObservable()
    }

    func send(_ searchText: String) {
        relay.accept(searchText)
    }
}

final class SearchModeStreamImpl: SearchModeStream, SearchModeSender {

    private let relay = BehaviorRelay(value: SearchMode.bySourceWord)

    static let instance = SearchModeStreamImpl()

    private init() { }

    var searchMode: Observable<SearchMode> {
        relay.asObservable()
    }

    func send(_ searchMode: SearchMode) {
        relay.accept(searchMode)
    }
}
