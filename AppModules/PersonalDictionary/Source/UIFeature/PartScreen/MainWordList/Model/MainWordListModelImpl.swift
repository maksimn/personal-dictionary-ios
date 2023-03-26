//
//  MainWordListModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.03.2023.
//

import RxSwift

final class MainWordListModelImpl: MainWordListModel {

    private let wordListRepository: WordListFetcher & WordCUDOperations
    private let translationService: TranslationService

    private let newWordIndex = 0

    init(wordListRepository: WordListFetcher & WordCUDOperations, translationService: TranslationService) {
        self.wordListRepository = wordListRepository
        self.translationService = translationService
    }

    func fetchMainWordList() -> WordListState {
        wordListRepository.wordList
    }

    func create(_ word: Word, state: WordListState) -> WordListState {
        var state = state
        
        state.insert(word, at: newWordIndex)
        
        return state
    }
    
    func createEffect(_ word: Word, state: WordListState) -> Single<WordListState> {
        wordListRepository.add(word)
            .flatMap { word in
                self.translationService.fetchTranslation(for: word)
            }
            .flatMap { translatedWord in
                self.wordListRepository.update(translatedWord)
            }
            .map { translatedWord in
                var state = state
                
                state[self.newWordIndex] = translatedWord
                
                return state
            }
    }
}
