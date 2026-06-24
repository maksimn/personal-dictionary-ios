//
//  DictionaryEntryDbInserter.swift
//  
//
//  Created by Maksim Ivanov on 10.05.2023.
//

import CoreModule
import Foundation
import RealmSwift

protocol DictionaryEntryDbInserter {

    func insert(entry: Data, for word: Word) async throws -> WordData
}

struct RealmDictionaryEntryDbInserter: DictionaryEntryDbInserter {

    func insert(entry: Data, for word: Word) async throws -> WordData {
        let wordData = WordData(word: word, entry: entry)

        return try await makeRealmCUD(operation: { (realm, wordData) in
            if let existingEntryDAO = realm.object(
                ofType: DictionaryEntryDAO.self, forPrimaryKey: wordData.word.id.raw) {
                existingEntryDAO.entry = wordData.entry
            } else {
                realm.add(DictionaryEntryDAO(wordData.word.id, wordData.entry))
            }
        }, with: wordData)
    }
}

struct DictionaryEntryDbInserterLog: DictionaryEntryDbInserter {

    let dbInserter: DictionaryEntryDbInserter
    let logger: CoreModule.Logger

    func insert(entry: Data, for word: Word) async throws -> WordData {
        logger.log("INSERT DICTIONARY ENTRY IN LOCAL STORAGE START\nENTRY=\(entry)\nWORD = \(word)", level: .info)

        do {
            let result = try await dbInserter.insert(entry: entry, for: word)

            logger.log(
                "INSERT DICTIONARY ENTRY IN LOCAL STORAGE SUCCESS\nENTRY=\(entry)\nWORD = \(result)",
                level: .info
            )

            return result
        } catch {
            logger.log("INSERT DICTIONARY ENTRY IN LOCAL STORAGE ERROR\nERROR = \(error)", level: .error)
            throw error
        }
    }
}
