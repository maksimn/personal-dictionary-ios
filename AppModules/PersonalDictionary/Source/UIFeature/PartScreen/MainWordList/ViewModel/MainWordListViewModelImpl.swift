//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import CoreModule
import RxSwift

final class MainWordListViewModelImpl: MainWordListViewModel {

    let state = BindableMainWordListState(value: MainWordListState(wordList: [], isHidden: false))

    private let wordListFetcher: WordListFetcher
    private let logger: SLogger
    private let disposeBag = DisposeBag()

    init(wordListFetcher: WordListFetcher, mainScreenStateStream: MainScreenStateStream, logger: SLogger) {
        self.wordListFetcher = wordListFetcher
        self.logger = logger
        subscribe(to: mainScreenStateStream.mainScreenState)
    }

    func fetch() {
        var state = state.value
        let wordList = wordListFetcher.wordList

        state.wordList = wordList
        self.state.accept(state)

        logger.logState(actionName: "FETCH MAIN WORDLIST", wordList)
    }

    private func subscribe(to mainScreenState: Observable<MainScreenState>) {
        mainScreenState.subscribe(onNext: { [weak self] in
            self?.onNext(mainScreenState: $0)
        }).disposed(by: disposeBag)
    }

    private func onNext(mainScreenState: MainScreenState) {
        var state = self.state.value

        switch mainScreenState {
        case .main:
            state.isHidden = false

        case .search:
            break
            
        case .empty:
            state.isHidden = true
        }

        self.state.accept(state)
    }
}
