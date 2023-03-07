//
//  WordListModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxSwift

/// Модель списка слов.
protocol WordListModel: AnyObject {

    func create(_ word: Word) -> Single<Word>

    func remove(_ word: Word) -> Single<Word>

    func update(_ word: Word) -> Single<Word>

    func fetchTranslationsFor(_ wordList: [Word], start: Int, end: Int) -> Observable<Word>
}
