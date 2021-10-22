//
//  SearchWordView.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.10.2021.
//

protocol SearchWordView: WordListView {

    func setNothingWasFoundLabel(hidden: Bool)

    func set(_ searchMode: SearchWordMode)
}
