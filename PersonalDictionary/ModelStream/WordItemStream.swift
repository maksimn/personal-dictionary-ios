//
//  WordItemStream.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 25.11.2021.
//

import RxSwift

protocol WordItemStream: AnyObject {

    var newWordItem: Observable<WordItem> { get }

    var removedWordItem: Observable<WordItem> { get }

    func sendNewWord(_ wordItem: WordItem)

    func sendRemovedWordItem(_ wordItem: WordItem)
}
