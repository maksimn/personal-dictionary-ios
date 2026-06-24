//
//  WordListRepositoryImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.10.2021.
//

import Realm
import RealmSwift

func realmWordListFilter(_ filter: (Results<WordDAO>) -> Results<WordDAO>) throws -> [Word] {
    let objects = try Realm().objects(WordDAO.self)
    let filtered = filter(objects)

    return filtered.sorted(byKeyPath: "createdAt", ascending: false)
        .compactMap { Word($0) }
}

func makeRealmCUD<T>(operation: @escaping (Realm, T) throws -> Void, with word: T) async throws -> T {
    try await Task.detached(priority: .medium) {
        let realm = try Realm()

        try realm.safeWrite {
            try operation(realm, word)
        }

        return word
    }.value
}

extension Realm {

    func findWordBy(id: Word.Id) throws -> WordDAO {
        guard let wordDAO = object(ofType: WordDAO.self, forPrimaryKey: id.raw) else {
            throw RealmWordError.wordNotFoundInRealm(id)
        }

        return wordDAO
    }

    func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}

enum RealmWordError: Error {
    case wordNotFoundInRealm(Word.Id)
}

func deleteAll<Element: RealmFetchable>(_ type: Element.Type) async throws where Element: RLMObjectBase {
    try await Task.detached(priority: .medium) {
        let realm = try Realm()
        let objs = realm.objects(type)

        try realm.write {
            realm.delete(objs)
        }
    }.value
}
