//
//  SearchWordView.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.10.2021.
//

protocol SearchWordView: WordListView {

    func setWordsNotFoundLabel(hidden: Bool)

    func set(_ searchMode: SearchWordMode)
}
