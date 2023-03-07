//
//  ManualMocks.swift
//  PersonalDictionaryDevTests
//
//  Created by Maksim Ivanov on 24.02.2023.
//

import CoreModule
import RxSwift
@testable import PersonalDictionary

enum TestError: Error { case err }

class MockLogger: SLogger {
    func log(_ message: String) { }
}

class MockHttpClient: HttpClient {

    var mockMethod: ((Http) -> Single<Data>)?

    func send(_ http: Http) -> Single<Data> {
        mockMethod!(http)
    }
}

class MockLangRepository: LangRepository {

    var mockAllLangs: [Lang]?
    var mockSetSourceLang: ((Lang) -> Void)?
    var mockSetTargetLang: ((Lang) -> Void)?

    var allLangs: [Lang] {
        mockAllLangs!
    }

    var sourceLang: Lang {
        get {
            fatalError()
        }
        set {
            mockSetSourceLang?(newValue)
        }
    }

    var targetLang: Lang {
        get {
            fatalError()
        }
        set {
            mockSetTargetLang?(newValue)
        }
    }
}

class MockWordListFetcher: WordListFetcher {

    var mockPropertyValue: [Word]?

    var wordList: [Word] {
        mockPropertyValue!
    }
}

class MockFavoriteWordListFetcher: FavoriteWordListFetcher {

    var mockPropertyValue: [Word]?

    var favoriteWordList: [Word] {
        mockPropertyValue!
    }
}

class MockReadableWordStream: ReadableWordStream {

    var newWord: Observable<Word> { .empty() }

    var removedWord: Observable<Word> { .empty() }

    var updatedWord: Observable<Word> { .empty() }
}

class MockLangPickerListener: LangPickerListener {

    var mockMethod: ((LangPickerState) -> Void)?

    func onLangPickerStateChanged(_ state: LangPickerState) {
        mockMethod!(state)
    }
}

class MockNewWordStream: NewWordStream {

    var methodMock: ((Word) -> Void)?

    func sendNewWord(_ word: Word) {
        methodMock!(word)
    }
}

class MockNewWordModel: NewWordModel {

    var mockSendNewWord: ((Word) -> Void)?

    func sendNewWord(_ word: Word) {
        mockSendNewWord!(word)
    }

    func save(sourceLang: Lang) { }

    func save(targetLang: Lang) { }
}

class MockMutableSearchTextStream: MutableSearchTextStream {

    var mockMethod: ((String) -> Void)?

    func send(_ searchText: String) {
        mockMethod?(searchText)
    }
}

class MockMutableSearchModeStream: MutableSearchModeStream {

    var mockMethod: ((SearchMode) -> Void)?

    func send(_ searchMode: SearchMode) {
        mockMethod?(searchMode)
    }
}

class MockSearchableWordList: SearchableWordList {

    var mockFindWords: ((String) -> [Word])?
    var mockFindWordsWhereTranslationContains: ((String) -> [Word])?

    func findWords(contain string: String) -> [Word] {
        mockFindWords!(string)
    }

    func findWords(whereTranslationContains string: String) -> [Word] {
        mockFindWordsWhereTranslationContains!(string)
    }
}

class MockSearchWordListModel: SearchWordListModel {

    var methodMock: ((String, SearchMode) -> SearchResultData)?

    func performSearch(for searchText: String, mode: SearchMode) -> SearchResultData {
        methodMock!(searchText, mode)
    }
}

class MockSearchTextStream: SearchTextStream {
    var searchText: Observable<String> { .empty() }
}

class MockSearchModeStream: SearchModeStream {
    var searchMode: Observable<SearchMode> { .empty() }
}

class MockWordListModel: WordListModel {

    var mockCreate: ((Word) -> Single<Word>)?
    var mockRemove: ((Word) -> Single<Word>)?
    var mockUpdate: ((Word) -> Single<Word>)?
    var mockFetchTranslationsFor: (([Word], Int, Int) -> Observable<Word>)?

    func create(_ word: Word) -> Single<Word> {
        mockCreate!(word)
    }
    func remove(_ word: Word) -> Single<Word> {
        mockRemove!(word)
    }
    func update(_ word: Word) -> Single<Word> {
        mockUpdate!(word)
    }
    func fetchTranslationsFor(_ wordList: [Word], start: Int, end: Int) -> Observable<Word> {
        mockFetchTranslationsFor!(wordList, start, end)
    }
}

class MockWordCUDOperations: WordCUDOperations {
    var mockAdd: ((Word) -> Single<Word>)?
    var mockRemove: ((Word) -> Single<Word>)?

    var mockUpdate: ((Word) -> Single<Word>)?

    func add(_ word: Word) -> Single<Word> {
        mockAdd!(word)
    }

    func update(_ word: Word) -> Single<Word> {
        mockUpdate!(word)
    }

    func remove(_ word: Word) -> Single<Word> {
        mockRemove!(word)
    }
}

class MockRUWordStream: UpdatedWordStream, RemovedWordStream {
    var mockSendUpdatedWord: ((Word) -> Void)?
    var mockSendRemovedWord: ((Word) -> Void)?

    func sendUpdatedWord(_ word: Word) {
        mockSendUpdatedWord!(word)
    }

    func sendRemovedWord(_ word: Word) {
        mockSendRemovedWord!(word)
    }
}

class MockTranslationService: TranslationService {
    var mockMethod: ((Word) -> Single<Word>)?

    func fetchTranslation(for word: Word) -> Single<Word> {
        mockMethod!(word)
    }
}
