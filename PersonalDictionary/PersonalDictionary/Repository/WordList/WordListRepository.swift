//
//  WordListRepository.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 06.10.2021.
//

import RxSwift

protocol WordListFetcher {

    var wordList: [WordItem] { get }
}

protocol WordItemCUDOperations {

    func add(_ wordItem: WordItem) -> Completable

    func update(_ wordItem: WordItem) -> Completable

    func remove(with wordItemId: WordItem.Id) -> Completable
}

protocol WordListRepository: WordListFetcher, WordItemCUDOperations {

}
