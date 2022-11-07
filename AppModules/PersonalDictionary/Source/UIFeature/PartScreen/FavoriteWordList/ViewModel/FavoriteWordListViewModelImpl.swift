//
//  WordListViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxCocoa

/// Реализация модели представления списка избранных слов.
final class FavoriteWordListViewModelImpl: FavoriteWordListViewModel {

    let favoriteWordList = BehaviorRelay<[Word]>(value: [])

    private let model: FavoriteWordListModel

    init(model: FavoriteWordListModel) {
        self.model = model
    }

    func update() {
        model.update()
    }
}
