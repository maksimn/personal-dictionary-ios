//
//  CreateWordDbWorker.swift
//  
//
//  Created by Maksim Ivanov on 10.05.2023.
//

import CoreModule
import RxSwift

protocol CreateWordDbWorker {

    /// Добавить слово в хранилище личного словаря
    /// - Parameters:
    ///  - word: слово для добавления.
    /// - Returns: Rx single для обработки завершения операции добавления слова в хранилище.
    func create(word: Word) -> Single<Word>
}

struct RealmCreateWordDbWorker: CreateWordDbWorker {

    func create(word: Word) -> Single<Word> {
        makeRealmCUD(operation: { (realm, word) in
            realm.add(WordDAO(word))
        }, with: word)
    }
}

struct CreateWordDbWorkerLog: CreateWordDbWorker {

    let createWordDbWorker: CreateWordDbWorker
    let logger: Logger

    func create(word: Word) -> Single<Word> {
        logger.log("CREATE WORD IN LOCAL STORAGE START\nWORD = \(word)", level: .info)

        let result = createWordDbWorker.create(word: word)
        let loggedResult = result.do(
            onSuccess: { word in
                logger.log("CREATE WORD IN LOCAL STORAGE SUCCESS\nWORD = \(word)", level: .info)

            },
            onError: { error in
                logger.log("CREATE WORD IN LOCAL STORAGE ERROR\nerror = \(error)", level: .error)
            }
        )

        return loggedResult
    }
}
