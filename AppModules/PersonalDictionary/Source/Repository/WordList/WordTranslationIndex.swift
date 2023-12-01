//
//  WordTranslationIndexDAO.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 01.12.2023.
//

import CoreModule
import RealmSwift
import RxSwift

// Логика работы с индексом переводов слов:
// 1) Создание объектов индекса - при успешном получении словарной статьи для слова создается набор объектов
// WordTranslationIndexDAO c переводами слова, который сохраняется в базе (Realm).
// 2) Удаление объектов индекса - при удалении слова из словаря удаляются все объекты WordTranslationIndexDAO для
// данного wordId.

class WordTranslationIndexDAO: Object {
    @Persisted var translations: List<String>
    @Persisted var wordId: String

    convenience init(translations: [String], wordId: String) {
        self.init()
        self.translations = List<String>()
        self.translations.append(objectsIn: translations)
        self.wordId = wordId
    }
}

protocol CreateWordTranslationIndexDbWorker {

    func createTranslationIndexFor(wordData: WordData) -> Single<WordData>
}

protocol DeleteWordTranslationIndexDbWorker {

    func deleteTranslationIndexFor(word: Word) -> Single<Word>
}

struct RealmCreateWordTranslationIndexDbWorker: CreateWordTranslationIndexDbWorker {

    let decoder: DictionaryEntryDecoder

    func createTranslationIndexFor(wordData: WordData) -> Single<WordData> {
        do {
            let dictionaryEntry = try decoder.decode(wordData.entry)
            let translations = dictionaryEntry.flatMap { $0.subitems }.map { $0.translation }

            return makeRealmCUD(
                operation: { (realm, obj) in realm.add(obj) },
                with: WordTranslationIndexDAO(translations: translations, wordId: wordData.word.id.raw)
            ).map { _ in
                wordData
            }
        } catch {
            return .error(error)
        }
    }
}

struct CreateWordTranslationIndexDbWorkerLog: CreateWordTranslationIndexDbWorker {

    let dbWorker: CreateWordTranslationIndexDbWorker
    let logger: CoreModule.Logger

    func createTranslationIndexFor(wordData: WordData) -> Single<WordData> {
        logger.log("CREATE TRANSLATION INDEX START, Word = \(wordData.word)", level: .info)

        let result = dbWorker.createTranslationIndexFor(wordData: wordData)
        let loggedResult = result.do(
            onSuccess: { wordData in
                logger.log("CREATE TRANSLATION INDEX SUCCESS, Word = \(wordData.word)", level: .info)
            },
            onError: { error in
                logger.log("CREATE TRANSLATION INDEX ERROR, Word = \(wordData.word)\nError = \(error)", level: .error)
            }
        )

        return loggedResult
    }
}

struct RealmDeleteWordTranslationIndexDbWorker: DeleteWordTranslationIndexDbWorker {

    func deleteTranslationIndexFor(word: Word) -> Single<Word> {
        makeRealmCUD(
            operation: { (realm, word) in
                let objects = realm.objects(WordTranslationIndexDAO.self).filter { $0.wordId == word.id.raw }

                realm.delete(objects)
            },
            with: word
        ).map { _ in
            word
        }
    }
}

struct DeleteWordTranslationIndexDbWorkerLog: DeleteWordTranslationIndexDbWorker {

    let dbWorker: DeleteWordTranslationIndexDbWorker
    let logger: CoreModule.Logger

    func deleteTranslationIndexFor(word: Word) -> Single<Word> {
        logger.log("DELETE TRANSLATION INDEX START, Word = \(word)", level: .info)

        let result = dbWorker.deleteTranslationIndexFor(word: word)
        let loggedResult = result.do(
            onSuccess: { word in
                logger.log("DELETE TRANSLATION INDEX SUCCESS, Word = \(word)", level: .info)
            },
            onError: { error in
                logger.log("DELETE TRANSLATION INDEX ERROR, Word = \(word)\nError = \(error)", level: .error)
            }
        )

        return loggedResult
    }
}
