//
//  SearchTextInputViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import CoreModule

final class SearchTextInputModelImpl: SearchTextInputModel {

    private let searchTextSender: SearchTextSender
    private let logger: Logger

    init(searchTextSender: SearchTextSender, logger: Logger) {
        self.searchTextSender = searchTextSender
        self.logger = logger
    }

    func process(_ searchText: String) {
        logger.logSending(searchText, toModelStream: "search text")

        searchTextSender.send(searchText)
    }
}
