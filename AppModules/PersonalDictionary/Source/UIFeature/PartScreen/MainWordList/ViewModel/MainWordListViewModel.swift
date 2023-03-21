//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

struct MainWordListState {
    var wordList: [Word]
    var isHidden: Bool
}

protocol MainWordListViewModel: AnyObject {

    /// Данные модели представления.
    var state: BindableMainWordListState { get }

    func fetch()
}
