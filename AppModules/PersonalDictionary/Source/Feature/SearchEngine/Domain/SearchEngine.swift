//
//  SearchEngine.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import RxSwift

/// Поисковый движок.
protocol SearchEngine {

    /// Найти слова, соответствующие параметрам поиска.
    /// - Parameters:
    ///  - string: строка для поиска.
    ///  - mode: режим поиска.
    /// - Returns: данные с результатом поиска.
    func findWords(contain string: String, mode: SearchMode) -> Single<SearchResultData>
}
