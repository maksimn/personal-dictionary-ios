//
//  WordListRepositoryImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.10.2021.
//

import CoreData
import CoreModule
import RxSwift
import Realm
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

            guard let dictionaryEntryDAO = realm.object(ofType: DictionaryEntryDAO.self,
                                                        forPrimaryKey: word.id.raw) else { return }

            realm.delete(dictionaryEntryDAO)
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
}

struct TranslationSearchableWordListImpl: TranslationSearchableWordList {

    func findWords(whereTranslationContains string: String) -> [Word] {
        let wordListFetcher = WordListFetcherImpl()
        var result: [Word] = []

        do {
            let words = try wordListFetcher.wordList()
            let realm = try Realm()

            for word in words {
                guard let dictionaryEntryDAO = realm.object(ofType: DictionaryEntryDAO.self,
                                                            forPrimaryKey: word.id.raw) else { continue }
                let dictionaryEntry = (
                    try? PonsDictionaryEntryDecoder().decode(dictionaryEntryDAO.entry, word: word)
                ) ?? []

                for entry in dictionaryEntry where (entry as NSString).localizedCaseInsensitiveContains(string) {
                    result.append(word)
                    break
                }
            }

            return result.sorted(by: { $0.createdAt > $1.createdAt })
        } catch {
            return []
        }
    }
}

struct DictionaryEntryDbWorkerImpl: DictionaryEntryDbWorker {

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

private func realmFilter(_ filter: (Results<WordDAO>) -> Results<WordDAO>) throws -> [Word] {
    let objects = try Realm().objects(WordDAO.self)
    let filtered = filter(objects)

    return filtered.sorted(byKeyPath: "createdAt", ascending: false)
        .compactMap { Word($0) }
}

private func makeRealmCUD<T>(operation: @escaping (Realm, T) throws -> Void, with word: T) -> Single<T> {
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
    case dictionaryEntryNotFoundInRealm(Word.Id)
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
