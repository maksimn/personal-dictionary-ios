//
//  WordItemStream.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 26.12.2022.
//

import RxSwift

protocol SearchTextStream {

    var searchText: Observable<String> { get }
}

protocol SearchTextSender {

    func send(_ searchText: String)
}

protocol SearchModeStream {

    var searchMode: Observable<SearchMode> { get }
}

protocol SearchModeSender {

    func send(_ searchMode: SearchMode)
}
