//
//  CreateWordDbWorker.swift
//  
//
//  Created by Maksim Ivanov on 10.05.2023.
//

import CoreModule

protocol DeleteWordDbWorker {

    /// Delete a word from the personal dictionary storage.
    /// - Parameters:
    ///  - word: the word to delete from the storage.
    /// - Returns: the deleted word.
    func delete(word: Word) async throws -> Word
}

struct RealmDeleteWordDbWorker: DeleteWordDbWorker {

    func delete(word: Word) async throws -> Word {
        try await makeRealmCUD(operation: { (realm, word) in
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

    func delete(word: Word) async throws -> Word {
        let result = try await deleteWordDbWorker.delete(word: word)

        return try await deleteWordTranslationIndexDbWorker.deleteTranslationIndexFor(word: result)
    }
}

struct DeleteWordDbWorkerLog: DeleteWordDbWorker {

    let deleteWordDbWorker: DeleteWordDbWorker
    let logger: Logger

    func delete(word: Word) async throws -> Word {
        logger.log("DELETE WORD AND ENTRY IN LOCAL STORAGE START\nWORD = \(word)", level: .info)

        do {
            let result = try await deleteWordDbWorker.delete(word: word)

            logger.log("DELETE WORD AND ENTRY IN LOCAL STORAGE SUCCESS\nWORD = \(result)", level: .info)

            return result
        } catch {
            logger.log("DELETE WORD AND ENTRY IN LOCAL STORAGE ERROR\nerror = \(error)", level: .error)
            throw error
        }
    }
}
