//
//  DictionaryEntryDbInserter.swift
//  
//
//  Created by Maksim Ivanov on 10.05.2023.
//

import CoreModule
import Foundation
import RealmSwift
import RxSwift

protocol DictionaryEntryDbInserter {

    func insert(entry: Data, for word: Word) -> Single<WordData>
}

struct RealmDictionaryEntryDbInserter: DictionaryEntryDbInserter {

    func insert(entry: Data, for word: Word) -> Single<WordData> {
        guard let realm = try? Realm() else {
            return .error(Realm.Error(Realm.Error.fail))
        }
        guard let entryDAO = realm.object(ofType: DictionaryEntryDAO.self, forPrimaryKey: word.id.raw) else {
            return makeRealmCUD(operation: { (realm, wordData) in
                realm.add(DictionaryEntryDAO(wordData.word.id, wordData.entry))
            }, with: WordData(word: word, entry: entry))
        }

        return makeRealmCUD(operation: { (_, wordData) in
            entryDAO.entry = wordData.entry
        }, with: WordData(word: word, entry: entry))
    }
}

struct DictionaryEntryDbInserterLog: DictionaryEntryDbInserter {

    let dbInserter: DictionaryEntryDbInserter
    let logger: CoreModule.Logger

    func insert(entry: Data, for word: Word) -> Single<WordData> {
        logger.log("INSERT DICTIONARY ENTRY IN LOCAL STORAGE START\nENTRY=\(entry)\nWORD = \(word)", level: .info)

        let result = dbInserter.insert(entry: entry, for: word)
        let loggedResult = result.do(
            onSuccess: { word in
                logger.log(
                    "INSERT DICTIONARY ENTRY IN LOCAL STORAGE SUCCESS\nENTRY=\(entry)\nWORD = \(word)",
                    level: .info
                )
            },
            onError: { error in
                logger.log("INSERT DICTIONARY ENTRY IN LOCAL STORAGE ERROR\nERROR = \(error)", level: .error)
            }
        )

        return loggedResult
    }
}
