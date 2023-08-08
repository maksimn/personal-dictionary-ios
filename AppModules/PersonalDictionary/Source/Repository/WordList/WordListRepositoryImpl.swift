//
//  WordListRepositoryImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.10.2021.
//

import CoreData
import CoreModule
import RxSwift
import RealmSwift

struct WordListFetcherImpl: WordListFetcher {

    func wordList() throws -> [Word] {
        try realmFilter { $0 }
    }
}

struct CreateWordDbWorkerImpl: CreateWordDbWorker {

    func create(word: Word) -> Single<Word> {
        makeRealmCUD(operation: { (realm, word) in
            realm.add(WordDAO(word))
        }, with: word)
    }
}

struct UpdateWordDbWorkerImpl: UpdateWordDbWorker {

    func update(word: Word) -> Single<Word> {
        makeRealmCUD(operation: { (realm, word) in
            let wordDAO = try realm.findWordBy(id: word.id)

            wordDAO.update(from: word)
        }, with: word)
    }
}

struct DeleteWordDbWorkerImpl: DeleteWordDbWorker {

    func delete(word: Word) -> Single<Word> {
        makeRealmCUD(operation: { (realm, word) in
            let wordDAO = try realm.findWordBy(id: word.id)

            realm.delete(wordDAO)
        }, with: word)
    }
}

struct FavoriteWordListFetcherImpl: FavoriteWordListFetcher {

    func favoriteWordList() throws -> [Word] {
       try realmFilter { $0.where { $0.isFavorite == true } }
    }
}

struct SearchableWordListImpl: SearchableWordList {

    func findWords(contain string: String) -> [Word] {
        (try? realmFilter { $0.filter("text contains[cd] \"\(string)\"") }) ?? []
    }

    func findWords(whereTranslationContains string: String) -> [Word] {
        (try? realmFilter { $0.filter("ANY dictionaryEntry contains[cd] \"\(string)\"") }) ?? []
    }
}

private func realmFilter(_ filter: (Results<WordDAO>) -> Results<WordDAO>) throws -> [Word] {
    let objects = try Realm().objects(WordDAO.self)
    let filtered = filter(objects)

    return filtered.sorted(byKeyPath: "createdAt", ascending: false)
        .compactMap { Word($0) }
}

private func makeRealmCUD(operation: @escaping (Realm, Word) throws -> Void, with word: Word) -> Single<Word> {
    .create { single in
        do {
            let realm = try Realm()

            try realm.write {
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
}

enum RealmWordError: Error {
    case wordNotFoundInRealm(Word.Id)
}
