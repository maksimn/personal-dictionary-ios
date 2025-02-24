//
//  ManualMocks.swift
//  PersonalDictionaryDevTests
//
//  Created by Maksim Ivanov on 24.02.2023.
//

import CoreModule
import Foundation
import RxSwift
@testable import PersonalDictionary

enum ErrorMock: Error { case err }

class LoggerMock: Logger {

    func log(_ message: String, level: LogLevel) { }
}

class HttpClientMock: HttpClient {

    var sendMock: ((Http) -> RxHttpResponse)?

    func send(_ http: Http) -> RxHttpResponse {
        sendMock!(http)
    }
}

class LangRepositoryMock: LangRepository {

    var allLangsMock: [Lang]?
    var getSourceLangMock: (() -> Lang)?
    var getTargetLangMock: (() -> Lang)?
    var setSourceLangMock: ((Lang) -> Void)?
    var setTargetLangMock: ((Lang) -> Void)?

    var allLangs: [Lang] {
        allLangsMock!
    }

    var sourceLang: Lang {
        get {
            getSourceLangMock!()
        }
        set {
            setSourceLangMock?(newValue)
        }
    }

    var targetLang: Lang {
        get {
            getTargetLangMock!()
        }
        set {
            setTargetLangMock?(newValue)
        }
    }
}

class WordListFetcherMock: WordListFetcher {

    var wordListMock: (() -> [Word])?

    func wordList() throws -> [Word] {
        wordListMock!()
    }
}

class FavoriteWordListFetcherMock: FavoriteWordListFetcher {

    var favoriteWordListMock: (() -> [Word])?

    func favoriteWordList() throws -> [Word] {
        favoriteWordListMock!()
    }
}

class NewWordStreamMock: NewWordStream {

    var newWord: Observable<Word> { .empty() }
}

class UpdatedWordStreamMock: UpdatedWordStream {

    var updatedWord: Observable<UpdatedWord> { .empty() }
}

class RemovedWordStreamMock: RemovedWordStream {

    var removedWord: Observable<Word> { .empty() }
}

class UpdatedRemovedWordStreamMock: UpdatedWordStream, RemovedWordStream {

    var updatedWord: Observable<UpdatedWord> { .empty() }

    var removedWord: Observable<Word> { .empty() }
}

class NewWordSenderMock: NewWordSender {

    var methodMock: ((Word) -> Void)?

    func sendNewWord(_ word: Word) {
        methodMock!(word)
    }
}

class SearchTextSenderMock: SearchTextSender {

    var methodMock: ((String) -> Void)?

    func send(_ searchText: String) {
        methodMock?(searchText)
    }
}

class SearchModeSenderMock: SearchModeSender {

    var methodMock: ((SearchMode) -> Void)?

    func send(_ searchMode: SearchMode) {
        methodMock?(searchMode)
    }
}

class SearchableWordListMock: SearchableWordList {
    var findWordsMock: ((String) -> [Word])?
    func findWords(contain string: String) -> [Word] {
        findWordsMock!(string)
    }
}

class TranslationSearchableWordListMock: TranslationSearchableWordList {
    var findWordsWhereTranslationContainsMock: ((String) -> [Word])?
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

    var removeMock: ((Int, WordListState) -> Single<WordListState>)? = { (_, _) in .error(ErrorMock.err) }
    var removeWordMock: ((Word, WordListState) -> Single<WordListState>)? = { (_, _) in .error(ErrorMock.err) }
    var toggleIsFavoriteMock: ((Int, WordListState) -> Single<WordListState>)? = { (_, _) in .error(ErrorMock.err) }
    var updateWordMock: ((UpdatedWord, WordListState) -> Single<WordListState>)? = { (_, _) in .error(ErrorMock.err) }

    func remove(at position: Int, state: WordListState) -> Single<WordListState> {
        removeMock!(position, state)
    }

    func remove(word: Word, state: WordListState) -> Single<WordListState> {
        removeWordMock!(word, state)
    }

    func toggleIsFavorite(at position: Int, state: WordListState) -> Single<WordListState> {
        toggleIsFavoriteMock!(position, state)
    }

    func update(word: UpdatedWord, state: WordListState) -> Single<WordListState> {
        updateWordMock!(word, state)
    }
}

class UpdatedWordSenderMock: UpdatedWordSender {
    var sendUpdatedWordMock: ((UpdatedWord) -> Void)? = { _ in }

    func sendUpdatedWord(_ updatedWord: UpdatedWord) {
        sendUpdatedWordMock!(updatedWord)
    }
}

class RemovedWordSenderMock: RemovedWordSender {
    var sendRemovedWordMock: ((Word) -> Void)? = { _ in }

    func sendRemovedWord(_ word: Word) {
        sendRemovedWordMock!(word)
    }
}

class DictionaryServiceMock: DictionaryService {
    var fetchDictionaryEntryMock: ((Word) -> Single<WordData>)?

    func fetchDictionaryEntry(for word: Word) -> Single<WordData> {
        fetchDictionaryEntryMock!(word)
    }
}

class MainWordListModelMock: MainWordListModel {

    var fetchMainWordListMock: (() -> WordListState)?
    var createMock: ((Word, WordListState) -> WordListState)?
    var createEffectMock: ((Word, WordListState) -> Single<WordListState>)?

    func fetchMainWordList() -> WordListState {
        fetchMainWordListMock!()
    }

    func create(_ word: Word, state: WordListState) -> WordListState {
        createMock!(word, state)
    }

    func createEffect(_ word: Word, state: WordListState) -> Single<WordListState> {
        createEffectMock!(word, state)
    }
}

class CreateWordDbWorkerMock: CreateWordDbWorker {

    var createWordMock: ((Word) -> Single<Word>)?

    func create(word: Word) -> Single<Word> {
        createWordMock!(word)
    }
}

class UpdateWordDbWorkerMock: UpdateWordDbWorker {
    var updateWordMock: ((Word) -> Single<Word>)? = { Single.just($0) }

    func update(word: Word) -> Single<Word> {
        updateWordMock!(word)
    }
}

class DeleteWordDbWorkerMock: DeleteWordDbWorker {
    var deleteWordMock: ((Word) -> Single<Word>)? = { Single.just($0) }

    func delete(word: Word) -> Single<Word> {
        deleteWordMock!(word)
    }
}

class WordListRouterMock: ParametrizedRouter {

    var navigateMock: ((Word.Id) -> Void)?

    func navigate(_ id: Word.Id) {
        navigateMock!(id)
    }
}

class DictionaryEntryModelMock: DictionaryEntryModel {
    var loadMock: (() throws -> DictionaryEntryVO)?
    var getDictionaryEntryMock: ((Word) -> Single<DictionaryEntryVO>)?
    func load() throws -> DictionaryEntryVO {
        try loadMock!()
    }
    func getDictionaryEntry(for word: Word) -> Single<DictionaryEntryVO> {
        getDictionaryEntryMock!(word)
    }
}

class DictionaryEntryDbInserterMock: DictionaryEntryDbInserter {
    var insertMock: ((Data, Word) -> Single<WordData>)? = { Single.just(WordData(word: $1, entry: $0)) }
    func insert(entry: Data, for word: Word) -> Single<WordData> {
        insertMock!(entry, word)
    }
}

class DictionaryEntryDecoderMock: DictionaryEntryDecoder {
    var decodeMock: (Data) -> DictionaryEntry = { (_) in [] }
    func decode(_ data: Data) throws -> DictionaryEntry {
        decodeMock(data)
    }
}

extension Word {

    static var defaultValueFUT: Word {
        Word(
            id: .init(raw: "AAAAAAAA-1111-2222-3333-444444444444"),
            text: "word", sourceLang: Lang.defaultValueFUT, targetLang: Lang.defaultValueFUT,
            createdAt: 123456789
        )
    }
}

extension Lang {

    static var defaultValueFUT: Lang {
        Lang(id: .init(raw: 1), nameKey: .init(raw: "Abc"), shortNameKey: .init(raw: "a"))
    }
}
