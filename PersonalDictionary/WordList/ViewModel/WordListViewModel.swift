//
//  WordListViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

protocol WordListViewModel: AnyObject {

    func add(_ wordItem: WordItem)

    var wordList: [WordItem] { get }
}
