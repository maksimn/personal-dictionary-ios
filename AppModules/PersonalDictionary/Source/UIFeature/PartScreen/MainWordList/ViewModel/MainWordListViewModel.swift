//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

protocol MainWordListViewModel: AnyObject {

    /// Данные модели представления.
    var wordList: BindableWordList { get }

    func fetch()
}
