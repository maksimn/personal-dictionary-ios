//
//  SearchInputStreamLog.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 12.01.2025.
//

import CoreModule

struct SearchTextStreamLog: SearchTextStream, SearchTextSender {

    let logger: Logger
    let modelStream: SearchTextStream & SearchTextSender

    private static let modelStreamName = "SEARCH TEXT"

    var searchText: AsyncStream<String> {
        AsyncStream { continuation in
            Task {
                for await text in modelStream.searchText {
                    logger.logReceiving(text, fromModelStream: Self.modelStreamName)
                    continuation.yield(text)
                }
                continuation.finish()
            }
        }
    }

    func send(_ searchText: String) {
        logger.logSending(searchText, toModelStream: Self.modelStreamName)

        modelStream.send(searchText)
    }
}

struct SearchModeStreamLog: SearchModeStream, SearchModeSender {

    let logger: Logger
    let modelStream: SearchModeStream & SearchModeSender

    private static let modelStreamName = "SEARCH MODE"

    var searchMode: AsyncStream<SearchMode> {
        AsyncStream { continuation in
            Task {
                for await mode in modelStream.searchMode {
                    logger.logReceiving(mode, fromModelStream: Self.modelStreamName)
                    continuation.yield(mode)
                }
                continuation.finish()
            }
        }
    }

    func send(_ searchMode: SearchMode) {
        logger.logSending(searchMode, toModelStream: Self.modelStreamName)

        modelStream.send(searchMode)
    }
}
