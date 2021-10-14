//
//  SearchWordViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.10.2021.
//

enum SearchWordMode {
    case bySourceWord, byTranslation
}

protocol SearchWordViewModel: WordListViewModel {

    var searchText: String { get set }

    var isWordsNotFoundLabelHidden: Bool { get set }

    var searchMode: SearchWordMode { get set }

    func prepareForSearching()
}
