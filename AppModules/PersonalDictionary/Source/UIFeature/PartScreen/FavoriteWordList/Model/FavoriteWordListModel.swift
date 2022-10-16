//
//  WordListModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

/// Модель списка избранных слов.
protocol FavoriteWordListModel: AnyObject {

    var isEmpty: Bool { get }

    func update()
}
