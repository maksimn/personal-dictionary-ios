//
//  SearchWordModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.10.2021.
//

protocol SearchWordModel: WordListModel {

    func prepareForSearching()

    func searchWord(contains string: String)

    func sendRemoveWordEvent(_ wordItem: WordItem)
}
