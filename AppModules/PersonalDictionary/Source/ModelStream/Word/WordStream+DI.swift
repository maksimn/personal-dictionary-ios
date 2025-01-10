//
//  WordStream+DI.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 12.01.2025.
//

import CoreModule

struct NewWordStreamFactory {

    let featureName: String

    func create() -> NewWordStream & NewWordSender {
        NewWordStreamLog(
            logger: LoggerImpl(category: featureName),
            modelStream: NewWordStreamImpl.instance
        )
    }
}

struct UpdatedWordStreamFactory {

    let featureName: String

    func create() -> UpdatedWordStream & UpdatedWordSender {
        UpdatedWordStreamLog(
            logger: LoggerImpl(category: featureName),
            modelStream: UpdatedWordStreamImpl.instance
        )
    }
}

struct RemovedWordStreamFactory {

    let featureName: String

    func create() -> RemovedWordStream & RemovedWordSender {
        RemovedWordStreamLog(
            logger: LoggerImpl(category: featureName),
            modelStream: RemovedWordStreamImpl.instance
        )
    }
}
