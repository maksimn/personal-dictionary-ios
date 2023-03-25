//
//  ManualMocks.swift
//  PersonalDictionaryDevTests
//
//  Created by Maksim Ivanov on 24.02.2023.
//

import CoreModule
import RxSwift
@testable import PersonalDictionary

enum ErrorMock: Error { case err }

class LoggerMock: Logger {

    func log(_ message: String, level: LogLevel) { }
}

class HttpClientMock: HttpClient {

    var methodMock: ((Http) -> RxHttpResponse)?

    func send(_ http: Http) -> RxHttpResponse {
        methodMock!(http)
    }
}

class LangRepositoryMock: LangRepository {

    var allLangsMock: [Lang]?
    var setSourceLangMock: ((Lang) -> Void)?
    var setTargetLangMock: ((Lang) -> Void)?

    var allLangs: [Lang] {
        allLangsMock!
    }

    var sourceLang: Lang {
        get {
            fatalError()
        }
        set {
            setSourceLangMock?(newValue)
        }
    }

    var targetLang: Lang {
        get {
            fatalError()
        }
        set {
            setTargetLangMock?(newValue)
        }
    }
}

class WordListFetcherMock: WordListFetcher {

    var propertyMock: [Word]?

    var wordList: [Word] {
        propertyMock!
    }
}

class FavoriteWordListFetcherMock: FavoriteWordListFetcher {

    var propertyMock: [Word]?

    var favoriteWordList: [Word] {
        propertyMock!
    }
}

class ReadableWordStreamMock: ReadableWordStream {

    var newWord: Observable<Word> { .empty() }

    var removedWord: Observable<Word> { .empty() }

    var updatedWord: Observable<Word> { .empty() }
}

class LangPickerListenerMock: LangPickerListener {

    var methodMock: ((LangPickerState) -> Void)?

    func onLangPickerStateChanged(_ state: LangPickerState) {
        methodMock!(state)
    }
}

class NewWordStreamMock: NewWordStream {

    var methodMock: ((Word) -> Void)?

    func sendNewWord(_ word: Word) {
        methodMock!(word)
    }
}

class NewWordModelMock: NewWordModel {

    var selectLangEffectMock: ((LangPickerState, NewWordState) -> NewWordState)?
    var sendNewWordMock: ((NewWordState) -> Void)?
    var presentLangPickerMock: ((LangType, NewWordState) -> NewWordState)?

    func selectLangEffect(_ langPickerState: LangPickerState, state: NewWordState) -> NewWordState {
        selectLangEffectMock!(langPickerState, state)
    }

    func presentLangPicker(langType: LangType, state: NewWordState) -> NewWordState {
        presentLangPickerMock!(langType, state)
    }

    func sendNewWord(_ state: NewWordState) {
        sendNewWordMock!(state)
    }
}

class MutableSearchTextStreamMock: MutableSearchTextStream {

    var methodMock: ((String) -> Void)?

    func send(_ searchText: String) {
        methodMock?(searchText)
    }
}

class MutableSearchModeStreamMock: MutableSearchModeStream {

    var methodMock: ((SearchMode) -> Void)?

    func send(_ searchMode: SearchMode) {
        methodMock?(searchMode)
    }
}

class SearchableWordListMock: SearchableWordList {

    var findWordsMock: ((String) -> [Word])?
    var findWordsWhereTranslationContainsMock: ((String) -> [Word])?

    func findWords(contain string: String) -> [Word] {
        findWordsMock!(string)
    }

    func findWords(whereTranslationContains string: String) -> [Word] {
        findWordsWhereTranslationContainsMock!(string)
    }
}

class SearchWordListModelMock: SearchWordListModel {

    var methodMock: ((String, SearchMode) -> SearchResultData)?

    func performSearch(for searchText: String, mode: SearchMode) -> SearchResultData {
        methodMock!(searchText, mode)
    }
}

class SearchTextStreamMock: SearchTextStream {
    var searchText: Observable<String> { .empty() }
}

class SearchModeStreamMock: SearchModeStream {
    var searchMode: Observable<SearchMode> { .empty() }
}

class WordListModelMock: WordListModel {
    var createMock: ((Word, WordListState) -> WordListState)?
    var createEffectMock: ((Word, WordListState) -> Single<WordListState>)?
    var removeMock: ((Int, WordListState) -> WordListState)?
    var removeEffectMock: ((Word, WordListState) -> Single<WordListState>)?
    var updateMock: ((Word, Int, WordListState) -> WordListState)?
    var updateEffectMock: ((Word, WordListState) -> Single<WordListState>)?
    var fetchTranslationsForMock: ((WordListState, Int, Int) -> Single<WordListState>)?

    func create(_ word: Word, state: WordListState) -> WordListState {
        createMock!(word, state)
    }

    func createEffect(_ word: Word, state: WordListState) -> Single<WordListState> {
        createEffectMock!(word, state)
    }

    func remove(at position: Int, state: WordListState) -> WordListState {
        removeMock!(position, state)
    }

    func removeEffect(_ word: Word, state: WordListState) -> Single<WordListState> {
        removeEffectMock!(word, state)
    }

    func update(_ word: Word, at position: Int, state: WordListState) -> WordListState {
        updateMock!(word, position, state)
    }

    func updateEffect(_ word: Word, state: WordListState) -> Single<WordListState> {
        updateEffectMock!(word, state)
    }

    func fetchTranslationsFor(state: WordListState, start: Int, end: Int) -> Single<WordListState> {
        fetchTranslationsForMock!(state, start, end)
    }
}

class WordCUDOperationsMock: WordCUDOperations {
    var addWordMock: ((Word) -> Single<Word>)?
    var removeWordMock: ((Word) -> Single<Word>)?
    var updateWordMock: ((Word) -> Single<Word>)?

    func add(_ word: Word) -> Single<Word> {
        addWordMock!(word)
    }

    func update(_ word: Word) -> Single<Word> {
        updateWordMock!(word)
    }

    func remove(_ word: Word) -> Single<Word> {
        removeWordMock!(word)
    }
}

class RUWordStreamMock: UpdatedWordStream, RemovedWordStream {
    var sendUpdatedWordMock: ((Word) -> Void)?
    var sendRemovedWordMock: ((Word) -> Void)?

    func sendUpdatedWord(_ word: Word) {
        sendUpdatedWordMock!(word)
    }

    func sendRemovedWord(_ word: Word) {
        sendRemovedWordMock!(word)
    }
}

class TranslationServiceMock: TranslationService {
    var methodMock: ((Word) -> Single<Word>)?

    func fetchTranslation(for word: Word) -> Single<Word> {
        methodMock!(word)
    }
}
