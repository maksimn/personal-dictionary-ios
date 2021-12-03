//
//  WordItemStreamImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 25.11.2021.
//

import RxSwift
import RxCocoa

final class WordItemStreamImpl: WordItemStream {

    private let newWordPublishRelay = PublishRelay<WordItem>()
    private let removedWordPublishRelay = PublishRelay<WordItem>()

    private init() {}

    static let instance = WordItemStreamImpl()

    var newWordItem: Observable<WordItem> {
        newWordPublishRelay.asObservable()
    }

    var removedWordItem: Observable<WordItem> {
        removedWordPublishRelay.asObservable()
    }

    func sendNewWord(_ wordItem: WordItem) {
        newWordPublishRelay.accept(wordItem)
    }

    func sendRemovedWordItem(_ wordItem: WordItem) {
        removedWordPublishRelay.accept(wordItem)
    }
}
