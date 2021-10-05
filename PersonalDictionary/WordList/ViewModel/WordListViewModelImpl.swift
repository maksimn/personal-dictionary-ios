//
//  WordListViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

final class WordListViewModelImpl: WordListViewModel {

    private unowned let view: WordListView
    private let model: WordListModel

    init(model: WordListModel, view: WordListView) {
        self.model = model
        self.view = view
    }
}
