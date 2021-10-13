//
//  SearchWordViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.10.2021.
//

enum SearchWordMode {
    case bySourceWord
    case byTranslation
}

protocol SearchWordViewModel: WordListViewModel {

    var isWordsNotFoundLabelHidden: Bool { get set }

    var searchMode: SearchWordMode { get set }

    func prepareForSearching()

    func searchWord(contains string: String)
}
