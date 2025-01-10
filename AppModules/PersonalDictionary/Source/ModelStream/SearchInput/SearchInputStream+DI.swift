//
//  SearchInputStream+DI.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 12.01.2025.
//

import CoreModule

struct SearchTextStreamFactory {

    let featureName: String

    func create() -> SearchTextStream & SearchTextSender {
        SearchTextStreamLog(
            logger: LoggerImpl(category: featureName),
            modelStream: SearchTextStreamImpl.instance
        )
    }
}

struct SearchModeStreamFactory {

    let featureName: String

    func create() -> SearchModeStream & SearchModeSender {
        SearchModeStreamLog(
            logger: LoggerImpl(category: featureName),
            modelStream: SearchModeStreamImpl.instance
        )
    }
}
