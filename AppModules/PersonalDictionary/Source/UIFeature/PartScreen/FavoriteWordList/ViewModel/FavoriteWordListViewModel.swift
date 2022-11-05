//
//  WordListViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxCocoa

/// Модель представления списка избранных слов.
protocol FavoriteWordListViewModel: AnyObject {

    var favoriteWordList: BehaviorRelay<[Word]> { get }

    func update()
}
