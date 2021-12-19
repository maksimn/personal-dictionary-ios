//
//  WordItemStream.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 25.11.2021.
//

import RxSwift

protocol ReadableWordItemStream: AnyObject {

    var newWordItem: Observable<WordItem> { get }

    var removedWordItem: Observable<WordItem> { get }
}

protocol NewWordItemStream: AnyObject {

    func sendNewWord(_ wordItem: WordItem)
}

protocol RemovedWordItemStream: AnyObject {

    func sendRemovedWordItem(_ wordItem: WordItem)
}

protocol WordItemStream: ReadableWordItemStream, NewWordItemStream, RemovedWordItemStream {
}
