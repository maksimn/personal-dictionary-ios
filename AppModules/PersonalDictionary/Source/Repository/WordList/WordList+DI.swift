//
//  WordListRepository+DI.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 06.10.2021.
//

import CoreModule

struct WordListFetcherFactory {

    let featureName: String

    func create() -> WordListFetcher {
        let realmWordListFetcher = RealmWordListFetcher()
        let wordListFetcherLog = WordListFetcherLog(
            wordListFetcher: realmWordListFetcher,
            logger: LoggerImpl(category: featureName)
        )

        return wordListFetcherLog
    }
}

struct FavoriteWordListFetcherFactory {

    let featureName: String

    func create() -> FavoriteWordListFetcher {
        let realmFavoriteWordListFetcher = RealmFavoriteWordListFetcher()
        let favoriteWordListFetcherLog = FavoriteWordListFetcherLog(
            favoriteWordListFetcher: realmFavoriteWordListFetcher,
            logger: LoggerImpl(category: featureName)
        )

        return favoriteWordListFetcherLog
    }
}

struct CreateWordDbWorkerFactory {

    let featureName: String

    func create() -> CreateWordDbWorker {
        let realmCreateWordDbWorker = RealmCreateWordDbWorker()
        let createWordDbWorkerLog = CreateWordDbWorkerLog(
            createWordDbWorker: realmCreateWordDbWorker,
            logger: LoggerImpl(category: featureName)
        )

        return createWordDbWorkerLog
    }
}

struct UpdateWordDbWorkerFactory {

    let featureName: String

    func create() -> UpdateWordDbWorker {
        let realmUpdateWordDbWorker = RealmUpdateWordDbWorker()
        let updateWordDbWorkerLog = UpdateWordDbWorkerLog(
            updateWordDbWorker: realmUpdateWordDbWorker,
            logger: LoggerImpl(category: featureName)
        )

        return updateWordDbWorkerLog
    }
}

struct DeleteWordDbWorkerFactory {

    let featureName: String

    func create() -> DeleteWordDbWorker {
        let realmDeleteWordDbWorker = RealmDeleteWordDbWorker()
        let deleteWordDbWorkerLog = DeleteWordDbWorkerLog(
            deleteWordDbWorker: realmDeleteWordDbWorker,
            logger: LoggerImpl(category: featureName)
        )

        return deleteWordDbWorkerLog
    }
}

struct DictionaryEntryDbInserterFactory {

    let featureName: String

    func create() -> DictionaryEntryDbInserter {
        let realmDictionaryEntryDbInserter = RealmDictionaryEntryDbInserter()
        let dictionaryEntryDbInserterLog = DictionaryEntryDbInserterLog(
            dbInserter: realmDictionaryEntryDbInserter,
            logger: LoggerImpl(category: featureName)
        )

        return dictionaryEntryDbInserterLog
    }
}

struct SearchableWordListFactory {

    let featureName: String

    func create() -> SearchableWordList {
        let realmSearchableWordList = RealmSearchableWordList()
        let searchableWordListLog = SearchableWordListLog(
            searchableWordList: realmSearchableWordList,
            logger: LoggerImpl(category: featureName)
        )

        return searchableWordListLog
    }
}

struct TranslationSearchableWordListFactory {

    let featureName: String

    func create() -> TranslationSearchableWordList {
        let realmTranslationSearchableWordList = RealmTranslationSearchableWordList()
        let translationSearchableWordListLog = TranslationSearchableWordListLog(
            translationSearchableWordList: realmTranslationSearchableWordList,
            logger: LoggerImpl(category: featureName)
        )

        return translationSearchableWordListLog
    }
}
