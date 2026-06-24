//
//  ManualMocks.swift
//  PersonalDictionaryDevTests
//
//  Created by Maksim Ivanov on 24.02.2023.
//

import CoreModule
import Foundation
@testable import PersonalDictionary

enum ErrorMock: Error { case err }

class LoggerMock: Logger {

    func log(_ message: String, level: LogLevel) { }
}

class HttpClientMock: HttpClient {

    var sendMock: ((Http) async throws -> HttpResponseResult)?

    func send(_ http: Http) async throws -> HttpResponseResult {
        try await sendMock!(http)
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

    var newWord: AsyncStream<Word> { AsyncStream { $0.finish() } }
}

class UpdatedWordStreamMock: UpdatedWordStream {

    var updatedWord: AsyncStream<UpdatedWord> { AsyncStream { $0.finish() } }
}

class RemovedWordStreamMock: RemovedWordStream {

    var removedWord: AsyncStream<Word> { AsyncStream { $0.finish() } }
}

class UpdatedRemovedWordStreamMock: UpdatedWordStream, RemovedWordStream {

    var updatedWord: AsyncStream<UpdatedWord> { AsyncStream { $0.finish() } }

    var removedWord: AsyncStream<Word> { AsyncStream { $0.finish() } }
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
    var searchText: AsyncStream<String> { AsyncStream { $0.finish() } }
}

class SearchModeStreamMock: SearchModeStream {
    var searchMode: AsyncStream<SearchMode> { AsyncStream { $0.finish() } }
}

class WordListModelMock: WordListModel {

    var removeMock: ((Int, WordListState) async throws -> WordListState)?
    var removeWordMock: ((Word, WordListState) async throws -> WordListState)?
    var toggleIsFavoriteMock: ((Int, WordListState) async throws -> WordListState)?
    var updateWordMock: ((UpdatedWord, WordListState) async throws -> WordListState)?

    func remove(at position: Int, state: WordListState) async throws -> WordListState {
        try await removeMock!(position, state)
    }

    func remove(word: Word, state: WordListState) async throws -> WordListState {
        try await removeWordMock!(word, state)
    }

    func toggleIsFavorite(at position: Int, state: WordListState) async throws -> WordListState {
        try await toggleIsFavoriteMock!(position, state)
    }

    func update(word: UpdatedWord, state: WordListState) async throws -> WordListState {
        try await updateWordMock!(word, state)
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
    var fetchDictionaryEntryMock: ((Word) async throws -> WordData)?

    func fetchDictionaryEntry(for word: Word) async throws -> WordData {
        try await fetchDictionaryEntryMock!(word)
    }
}

class MainWordListModelMock: MainWordListModel {

    var fetchMainWordListMock: (() -> WordListState)?
    var createMock: ((Word, WordListState) -> WordListState)?
    var createEffectMock: ((Word, WordListState) async throws -> WordListState)?

    func fetchMainWordList() -> WordListState {
        fetchMainWordListMock!()
    }

    func create(_ word: Word, state: WordListState) -> WordListState {
        createMock!(word, state)
    }

    func createEffect(_ word: Word, state: WordListState) async throws -> WordListState {
        try await createEffectMock!(word, state)
    }
}

class CreateWordDbWorkerMock: CreateWordDbWorker {

    var createWordMock: ((Word) async throws -> Word)?

    func create(word: Word) async throws -> Word {
        try await createWordMock!(word)
    }
}

class UpdateWordDbWorkerMock: UpdateWordDbWorker {
    var updateWordMock: ((Word) async throws -> Word)? = { $0 }

    func update(word: Word) async throws -> Word {
        try await updateWordMock!(word)
    }
}

class DeleteWordDbWorkerMock: DeleteWordDbWorker {
    var deleteWordMock: ((Word) async throws -> Word)? = { $0 }

    func delete(word: Word) async throws -> Word {
        try await deleteWordMock!(word)
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
    var getDictionaryEntryMock: ((Word) async throws -> DictionaryEntryVO)?
    func load() throws -> DictionaryEntryVO {
        try loadMock!()
    }
    func getDictionaryEntry(for word: Word) async throws -> DictionaryEntryVO {
        try await getDictionaryEntryMock!(word)
    }
}

class DictionaryEntryDbInserterMock: DictionaryEntryDbInserter {
    var insertMock: ((Data, Word) async throws -> WordData)? = { WordData(word: $1, entry: $0) }
    func insert(entry: Data, for word: Word) async throws -> WordData {
        try await insertMock!(entry, word)
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
