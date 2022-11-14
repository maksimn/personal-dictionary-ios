//
//  WordListModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

protocol SearchWordListModel: AnyObject {

    func performSearch(for searchText: String, mode: SearchMode)
}
