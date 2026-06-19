//
//  NetworkingService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import RxSwift

/// Service for fetching a dictionary entry for a word.
protocol DictionaryService {

    /// Fetch the translation of a word.
    /// - Parameters:
    ///  - word: the word.
    /// - Returns:
    ///  - Rx Single with the word containing its dictionary entry.
    func fetchDictionaryEntry(for word: Word) -> Single<WordData>
}
