//
//  WordListViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

protocol WordListViewModel: AnyObject {

    var wordList: [WordItem] { get set }

    func fetchDataFromModel()

    func add(_ wordItem: WordItem)

    func update(_ wordItem: WordItem, _ position: Int)

    func remove(_ wordItem: WordItem, _ position: Int)

    func navigateToNewWord()

    func navigateToSearch()
}
