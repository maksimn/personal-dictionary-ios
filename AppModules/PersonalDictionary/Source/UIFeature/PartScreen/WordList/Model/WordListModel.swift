//
//  WordListModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxSwift

/// Модель списка слов.
protocol WordListModel: AnyObject {

    func create(_ word: Word) -> Completable

    func remove(_ word: Word) -> Completable

    func update(_ word: Word) -> Completable

    func fetchTranslationsFor(_ wordList: [Word], start: Int, end: Int) -> Completable
}
