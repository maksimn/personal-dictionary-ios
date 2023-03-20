//
//  WordItemStream.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 26.12.2022.
//

import RxSwift

enum MainScreenState { case main, search }

protocol MainScreenStateStream {

    var mainScreenState: Observable<MainScreenState> { get }
}

protocol MutableMainScreenStateStream {

    func send(_ mainScreenState: MainScreenState)
}
