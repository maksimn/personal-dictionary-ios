//
//  WordListRepository.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 06.10.2021.
//

protocol WordListFetcher {

    var wordList: [WordItem] { get }
}

protocol WordListCUDOperations {

    func add(_ wordItem: WordItem, completion: ((Error?) -> Void)?)

    func update(_ wordItem: WordItem, completion: ((Error?) -> Void)?)

    func remove(with wordItemId: WordItem.Id, completion: ((Error?) -> Void)?)
}

protocol WordListRepository: WordListFetcher, WordListCUDOperations {

}
