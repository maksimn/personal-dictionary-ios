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
    var mockSetSourceLang: (() -> Void)?
    var mockSetTargetLang: (() -> Void)?

    init(allLangsValue: [Lang]) {
        self.allLangsValue = allLangsValue
    }

    var allLangs: [Lang] {
        allLangsValue
    }

    var sourceLang: Lang {
        get {
            defaultLang
        }
        set {
            mockSetSourceLang?()
        }
    }

    var targetLang: Lang {
        get {
            defaultLang
        }
        set {
            mockSetTargetLang?()
        }
    }
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

class MockNewWordStream: NewWordStream {

    var methodMock: (() -> Void)?

    func sendNewWord(_ word: Word) {
        methodMock?()
    }
}

class MockNewWordModel: NewWordModel {

    var mockSendNewWord: (() -> Void)?

    func sendNewWord(_ word: Word) {
        mockSendNewWord?()
    }

    func save(sourceLang: Lang) { }

    func save(targetLang: Lang) { }
}

class MockMutableSearchTextStream: MutableSearchTextStream {

    var mockMethod: (() -> Void)?

    func send(_ searchText: String) {
        mockMethod?()
    }
}

class MockMutableSearchModeStream: MutableSearchModeStream {

    var mockMethod: (() -> Void)?

    func send(_ searchMode: SearchMode) {
        mockMethod?()
    }
}

class MockSearchableWordList: SearchableWordList {

    var mockFindWordsResult: [Word]?
    var mockFindWordsWhereTranslationContainsResult: [Word]?

    func findWords(contain string: String) -> [Word] {
        mockFindWordsResult!
    }

    func findWords(whereTranslationContains string: String) -> [Word] {
        mockFindWordsWhereTranslationContainsResult!
    }
}

class MockSearchWordListModel: SearchWordListModel {

    var mockSearchResult: SearchResultData?

    func performSearch(for searchText: String, mode: SearchMode) -> SearchResultData {
        mockSearchResult!
    }
}

class MockSearchTextStream: SearchTextStream {
    var searchText: Observable<String> { Observable<String>.empty() }
}

class MockSearchModeStream: SearchModeStream {
    var searchMode: Observable<SearchMode> { Observable<SearchMode>.empty() }
}

class MockWordListModel: WordListModel {
    func create(_ word: Word) -> Completable {
        .empty()
    }
    func fetchTranslationsFor(_ notTranslated: [Word]) -> Observable<Word> {
        .empty()
    }
    func remove(_ word: Word) -> Completable {
        .empty()
    }
    func update(_ word: Word) -> Completable {
        .empty()
    }
}
