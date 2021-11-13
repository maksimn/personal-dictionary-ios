//
//  SearchEngine.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

protocol SearchEngine {

    func findItems(contain string: String, mode: SearchMode, completion: @escaping (SearchResultData) -> Void)
}
