//
//  SearchTextInputViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import CoreModule

final class SearchTextInputModelImpl: SearchTextInputModel {

    private let searchTextStream: MutableSearchTextStream
    private let logger: Logger

    init(searchTextStream: MutableSearchTextStream, logger: Logger) {
        self.searchTextStream = searchTextStream
        self.logger = logger
    }

    func process(_ searchText: String) {
        logger.logSending(searchText, toModelStream: "search text")

        searchTextStream.send(searchText)
    }
}
