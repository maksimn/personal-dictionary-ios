//
//  SearchWordViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.10.2021.
//

protocol SearchWordViewModel: WordListViewModel {

    var isMessageLabelHidden: Bool { get set }

    func prepareForSearching()

    func searchWord(contains string: String)
}
