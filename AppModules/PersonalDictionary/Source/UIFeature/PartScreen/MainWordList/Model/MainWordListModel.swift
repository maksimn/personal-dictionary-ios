//
//  MainWordListModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.03.2023.
//

import RxSwift

protocol MainWordListModel {

    func fetchMainWordList() -> WordListState

    func create(_ word: Word, state: WordListState) -> WordListState

    func createEffect(_ word: Word, state: WordListState) -> Single<WordListState>
}
