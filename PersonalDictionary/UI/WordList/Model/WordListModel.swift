//
//  WordListModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

protocol WordListModel {

    var viewModel: WordListViewModel? { get set }

    func fetchWordList()

    func removeFromRepository(_ wordItem: WordItem)
}
