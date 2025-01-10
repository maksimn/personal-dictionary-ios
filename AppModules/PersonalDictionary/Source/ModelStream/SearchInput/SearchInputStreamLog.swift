//
//  SearchInputStreamLog.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 12.01.2025.
//

import CoreModule
import RxSwift

struct SearchTextStreamLog: SearchTextStream, SearchTextSender {

    let logger: Logger
    let modelStream: SearchTextStream & SearchTextSender

    private static let modelStreamName = "SEARCH TEXT"

    var searchText: Observable<String> {
        modelStream.searchText.do(onNext: { searchText in
            logger.logReceiving(searchText, fromModelStream: SearchTextStreamLog.modelStreamName)
        })
    }

    func send(_ searchText: String) {
        logger.logSending(searchText, toModelStream: SearchTextStreamLog.modelStreamName)

        modelStream.send(searchText)
    }
}

struct SearchModeStreamLog: SearchModeStream, SearchModeSender {

    let logger: Logger
    let modelStream: SearchModeStream & SearchModeSender

    private static let modelStreamName = "SEARCH MODE"

    var searchMode: Observable<SearchMode> {
        modelStream.searchMode.do(onNext: { searchMode in
            logger.logReceiving(searchMode, fromModelStream: SearchModeStreamLog.modelStreamName)
        })
    }

    func send(_ searchMode: SearchMode) {
        logger.logSending(searchMode, toModelStream: SearchModeStreamLog.modelStreamName)

        modelStream.send(searchMode)
    }
}
