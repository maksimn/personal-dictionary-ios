//
//  SearchEngine.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import RxSwift

protocol SearchEngine {

    func findItems(contain string: String, mode: SearchMode) -> Single<SearchResultData>
}
