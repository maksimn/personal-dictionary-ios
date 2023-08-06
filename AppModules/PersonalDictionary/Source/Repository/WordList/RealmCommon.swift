//
//  WordListRepository.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import RealmSwift

func makeRealmCUD(operation: (Realm, Word) throws -> Void, with word: Word) async throws {
    return try await withCheckedThrowingContinuation { continuation in
        do {
            let realm = try Realm()

            try realm.write {
                do {
                    try operation(realm, word)
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        } catch {
            continuation.resume(throwing: error)
        }
    }
}

extension Realm {

    func findWordBy(id: Word.Id) throws -> WordDAO {
        guard let wordDAO = object(ofType: WordDAO.self, forPrimaryKey: id.raw) else {
            throw RealmWordError.wordNotFoundInRealm(id)
        }

        return wordDAO
    }
}

enum RealmWordError: Error {
    case wordNotFoundInRealm(Word.Id)
}
