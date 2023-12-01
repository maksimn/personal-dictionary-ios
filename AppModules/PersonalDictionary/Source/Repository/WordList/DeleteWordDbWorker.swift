//
//  CreateWordDbWorker.swift
//  
//
//  Created by Maksim Ivanov on 10.05.2023.
//

import CoreModule
import RxSwift

protocol DeleteWordDbWorker {

    /// Удалить слово из хранилища личного словаря
    /// - Parameters:
    ///  - word: слово для его удаления из хранилища.
    /// - Returns: Rx single для обработки завершения операции удаления слова из хранилища.
    func delete(word: Word) -> Single<Word>
}

struct RealmDeleteWordDbWorker: DeleteWordDbWorker {

    func delete(word: Word) -> Single<Word> {
        makeRealmCUD(operation: { (realm, word) in
            let wordDAO = try realm.findWordBy(id: word.id)

            realm.delete(wordDAO)

            guard let dictionaryEntryDAO = realm.object(ofType: DictionaryEntryDAO.self,
                                                        forPrimaryKey: word.id.raw) else { return }

            realm.delete(dictionaryEntryDAO)
        }, with: word)
    }
}

struct CleanTranslationIndexDeleteWordDbWorker: DeleteWordDbWorker {

    let deleteWordDbWorker: DeleteWordDbWorker
    let deleteWordTranslationIndexDbWorker: DeleteWordTranslationIndexDbWorker

    func delete(word: Word) -> Single<Word> {
        deleteWordDbWorker.delete(word: word)
            .flatMap {
                deleteWordTranslationIndexDbWorker.deleteTranslationIndexFor(word: $0)
            }
    }
}

struct DeleteWordDbWorkerLog: DeleteWordDbWorker {

    let deleteWordDbWorker: DeleteWordDbWorker
    let logger: Logger

    func delete(word: Word) -> Single<Word> {
        logger.log("DELETE WORD AND ENTRY IN LOCAL STORAGE START\nWORD = \(word)", level: .info)

        let result = deleteWordDbWorker.delete(word: word)
        let loggedResult = result.do(
            onSuccess: { word in
                logger.log("DELETE WORD AND ENTRY IN LOCAL STORAGE SUCCESS\nWORD = \(word)", level: .info)

            },
            onError: { error in
                logger.log("DELETE WORD AND ENTRY IN LOCAL STORAGE ERROR\nerror = \(error)", level: .error)
            }
        )

        return loggedResult
    }
}
