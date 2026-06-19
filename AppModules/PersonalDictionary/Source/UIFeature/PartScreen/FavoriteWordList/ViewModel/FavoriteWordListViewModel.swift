//
//  WordListViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

/// View model of the favorite word list.
protocol FavoriteWordListViewModel: AnyObject {

    var favoriteWordList: BindableWordList { get }

    func fetchFavoriteWordList()
}
