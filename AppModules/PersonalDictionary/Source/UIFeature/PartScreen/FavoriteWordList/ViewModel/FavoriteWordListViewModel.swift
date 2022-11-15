//
//  WordListViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

/// Модель представления списка избранных слов.
protocol FavoriteWordListViewModel: AnyObject {

    var favoriteWordList: BindableWordList { get }

    func update()
}
