//
//  SearchInputStream.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 26.12.2022.
//

protocol SearchTextStream {

    var searchText: AsyncStream<String> { get }
}

protocol SearchTextSender {

    func send(_ searchText: String)
}

protocol SearchModeStream {

    var searchMode: AsyncStream<SearchMode> { get }
}

protocol SearchModeSender {

    func send(_ searchMode: SearchMode)
}

enum SearchMode {
    case bySourceWord
    case byTranslation
}
