//
//  WordListFetcher.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 06.10.2021.
//

import CoreModule
import RealmSwift

/// Получение списка избранных слов из хранилища личного словаря.
protocol FavoriteWordListFetcher {

    /// - Returns: список  избранных слов из личного словаря.
    func favoriteWordList() throws -> [Word]
}

struct RealmFavoriteWordListFetcher: FavoriteWordListFetcher {

    func favoriteWordList() throws -> [Word] {
        try realmWordListFilter { $0.where { $0.isFavorite == true } }
    }
}

struct FavoriteWordListFetcherLog: FavoriteWordListFetcher {

    let favoriteWordListFetcher: FavoriteWordListFetcher
    let logger: CoreModule.Logger

    func favoriteWordList() throws -> [Word] {
        do {
            logger.log("Fetching favorite word list from the device storage...", level: .info)

            let result = try favoriteWordListFetcher.favoriteWordList()

            logger.log("Favorite word list fetched from the device storage: \(result)", level: .info)

            return result
        } catch {
            logger.log("Error of fetching the favorite word list from the device storage: \(error)", level: .error)

            throw error
        }
    }
}
