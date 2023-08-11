//
//  NetworkingService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import RxSwift

/// Служба для получения перевода слова.
protocol DictionaryService {

    /// Извлечь перевод слова.
    /// - Parameters:
    ///  - word: слово для перевода.
    /// - Returns:
    ///  - Rx Single с переведенным словом
    func fetchDictionaryEntry(for word: Word) -> Single<Word>
}
