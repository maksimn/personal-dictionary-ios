//
//  WordListModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import CoreModule
import RxSwift

final class MainSwitchModel: Model {

    var presenter: MainSwitchPresenter?

    private var state: MainScreenState

    private let mainScreenStateStream: MainScreenStateStream
    private let logger: SLogger

    private let disposeBag = DisposeBag()

    init(initialState: MainScreenState, mainScreenStateStream: MainScreenStateStream, logger: SLogger) {
        self.state = initialState
        self.mainScreenStateStream = mainScreenStateStream
        self.logger = logger
        subscribe()
    }

    private func onNext(mainScreenState: MainScreenState) {
        logger.log("Received mainScreenState = \(mainScreenState) from the MAIN SCREEN STATE model stream.")

        if mainScreenState != state {
            presenter?.update(mainScreenState)
        }

        state = mainScreenState
    }

    private func subscribe() {
        mainScreenStateStream.mainScreenState.subscribe(onNext: { [weak self] state in
            self?.onNext(mainScreenState: state)
        }).disposed(by: disposeBag)
    }
}
