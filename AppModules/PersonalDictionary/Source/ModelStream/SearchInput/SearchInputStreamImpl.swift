//
//  SearchInputStreamImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 26.12.2022.
//

import Foundation

final class SearchTextStreamImpl: SearchTextStream, SearchTextSender {

    private var continuation: AsyncStream<String>.Continuation?

    let searchText: AsyncStream<String>

    static let instance = SearchTextStreamImpl()

    private init() {
        var cont: AsyncStream<String>.Continuation?
        searchText = AsyncStream { continuation in
            cont = continuation
        }
        continuation = cont
    }

    func send(_ searchText: String) {
        continuation?.yield(searchText)
    }
}

final class SearchModeStreamImpl: SearchModeStream, SearchModeSender {

    private var continuation: AsyncStream<SearchMode>.Continuation?

    let searchMode: AsyncStream<SearchMode>

    static let instance = SearchModeStreamImpl()

    private init() {
        var cont: AsyncStream<SearchMode>.Continuation?
        searchMode = AsyncStream { continuation in
            cont = continuation
        }
        continuation = cont
    }

    func send(_ searchMode: SearchMode) {
        continuation?.yield(searchMode)
    }
}
