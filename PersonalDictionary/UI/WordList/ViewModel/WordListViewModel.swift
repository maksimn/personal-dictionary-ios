//
//  WordListViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

protocol WordListViewModel: AnyObject {

    var wordListData: WordListData { get set }

    func fetchData()

    func remove(_ wordItem: WordItem, at position: Int)

    func navigateToNewWord()

    func navigateToSearch()
}
