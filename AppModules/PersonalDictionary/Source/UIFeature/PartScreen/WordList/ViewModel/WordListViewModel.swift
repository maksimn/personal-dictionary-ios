//
//  WordListViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

protocol WordListViewModel: AnyObject {

    var wordListData: WordListData { get set }

    func remove(_ wordItem: WordItem, at position: Int)

    func sendRemovedWordItem(_ wordItem: WordItem)

    func requestTranslationsIfNeededWithin(startPosition: Int, endPosition: Int)
}
