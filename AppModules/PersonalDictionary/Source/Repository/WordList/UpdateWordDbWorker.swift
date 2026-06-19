//
//  UpdateWordDbWorker.swift
//  
//
//  Created by Maksim Ivanov on 10.05.2023.
//

import CoreModule
import RxSwift

protocol UpdateWordDbWorker {

    /// Update a word in the personal dictionary storage.
    /// - Parameters:
    ///  - word: the updated word.
    /// - Returns: Rx single for handling the completion of the word update operation.
    func update(word: Word) -> Single<Word>
}

struct RealmUpdateWordDbWorker: UpdateWordDbWorker {

    func update(word: Word) -> Single<Word> {
        makeRealmCUD(operation: { (realm, word) in
            let wordDAO = try realm.findWordBy(id: word.id)

            wordDAO.update(from: word)
        }, with: word)
    }
}

struct UpdateWordDbWorkerLog: UpdateWordDbWorker {

    let updateWordDbWorker: UpdateWordDbWorker
    let logger: Logger

    func update(word: Word) -> Single<Word> {
        logger.log("UPDATE WORD IN LOCAL STORAGE START\nWORD = \(word)", level: .info)

        let result = updateWordDbWorker.update(word: word)
        let loggedResult = result.do(
            onSuccess: { word in
                logger.log("UPDATE WORD IN LOCAL STORAGE SUCCESS\nWORD = \(word)", level: .info)

            },
            onError: { error in
                logger.log("UPDATE WORD IN LOCAL STORAGE ERROR\nerror = \(error)", level: .error)
            }
        )

        return loggedResult
    }
}
