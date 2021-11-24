//
//  WordListModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

protocol WordListModel: AnyObject {

    var data: WordListData { get set }

    func remove(_ wordItem: WordItem, at position: Int)

    func requestTranslationsIfNeededWithin(startPosition: Int, endPosition: Int)
}
