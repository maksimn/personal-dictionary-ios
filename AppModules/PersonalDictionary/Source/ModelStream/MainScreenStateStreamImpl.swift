//
//  WordItemStreamImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 26.12.2022.
//

import RxSwift
import RxCocoa

final class MainScreenStateStreamImpl: MainScreenStateStream, MutableMainScreenStateStream {

    private let relay = BehaviorRelay<MainScreenState>(value: .main)

    static let instance = MainScreenStateStreamImpl()

    private init() { }

    var mainScreenState: Observable<MainScreenState> {
        relay.asObservable()
    }

    func send(_ mainScreenState: MainScreenState) {
        relay.accept(mainScreenState)
    }
}
