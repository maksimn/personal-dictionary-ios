//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

protocol MainWordListViewModel {

    /// View model data.
    var wordList: WordListState { get }

    func fetch()
}
