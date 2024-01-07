//
//  WordListRepositoryImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.10.2021.
//

import RxSwift
import Realm
import RealmSwift

func realmWordListFilter(_ filter: (Results<WordDAO>) -> Results<WordDAO>) throws -> [Word] {
    let objects = try Realm().objects(WordDAO.self)
    let filtered = filter(objects)

    return filtered.sorted(byKeyPath: "createdAt", ascending: false)
        .compactMap { Word($0) }
}

func makeRealmCUD<T>(operation: @escaping (Realm, T) throws -> Void, with word: T) -> Single<T> {
    .create { single in
        do {
            let realm = try Realm()

            try realm.safeWrite {
                do {
                    try operation(realm, word)
                    single(.success(word))
                } catch {
                    single(.failure(error))
                }
            }
        } catch {
            single(.failure(error))
        }

        return Disposables.create {}
    }
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

func deleteAll<Element: RealmFetchable>(_ type: Element.Type) -> Completable where Element: RLMObjectBase {
    .create { completable in
        do {
            let realm = try Realm()
            let objs = realm.objects(type)

            try realm.write {
                realm.delete(objs)
                completable(.completed)
            }
        } catch {
            completable(.error(error))
        }

        return Disposables.create {}
    }
}
