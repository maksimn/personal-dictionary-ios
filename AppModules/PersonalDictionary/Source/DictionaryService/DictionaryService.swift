//
//  NetworkingService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import RxSwift

/// Служба для получения словарной статьи для слова.
protocol DictionaryService {

    /// Извлечь перевод слова.
    /// - Parameters:
    ///  - word: слово.
    /// - Returns:
    ///  - Rx Single со словом, содержащим словарную статью о нём.
    func fetchDictionaryEntry(for word: Word) -> Single<WordData>
}
