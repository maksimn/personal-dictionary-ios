//
//  ManualMocks.swift
//  PersonalDictionaryDevTests
//
//  Created by Maksim Ivanov on 24.02.2023.
//

import CoreModule
import RxSwift
@testable import PersonalDictionary

class LoggerStub: SLogger {
    func log(_ message: String) { }
}

class MockHttpClient: HttpClient {

    private let returnValue: Single<Data>

    init(returnValue: Single<Data>) {
        self.returnValue = returnValue
    }

    func send(_ http: Http) -> Single<Data> {
        returnValue
    }
}

class MockLangRepository: LangRepository {

    let allLangsValue: [Lang]
    let defaultLang = Lang(id: .init(raw: 0), name: "", shortName: "")

    init(allLangsValue: [Lang]) {
        self.allLangsValue = allLangsValue
    }

    var allLangs: [Lang] {
        allLangsValue
    }

    lazy var sourceLang: Lang = defaultLang

    lazy var targetLang: Lang = defaultLang
}

class MockWordListFetcher: WordListFetcher {

    let returnValue: [Word]

    init(returnValue: [Word]) {
        self.returnValue = returnValue
    }

    var wordList: [Word] {
        returnValue
    }
}

class MockFavoriteWordListFetcher: FavoriteWordListFetcher {

    let returnValue: [Word]

    init(returnValue: [Word]) {
        self.returnValue = returnValue
    }

    var favoriteWordList: [Word] {
        returnValue
    }
}

class MockReadableWordStream: ReadableWordStream {

    var newWord: Observable<Word> {
        Observable<Word>.empty()
    }

    var removedWord: Observable<Word> {
        Observable<Word>.empty()
    }

    var updatedWord: Observable<Word> {
        Observable<Word>.empty()
    }
}

class MockLangPickerListener: LangPickerListener {

    let callback: () -> Void

    init(_ callback: @escaping () -> Void) {
        self.callback = callback
    }

    func onLangPickerStateChanged(_ state: LangPickerState) {
        callback()
    }
}
