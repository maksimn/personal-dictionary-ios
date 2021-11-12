//
//  SearchTextInputViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

protocol SearchTextInputViewModel: AnyObject {

    var searchText: String { get set }

    func updateModel(_ searchText: String)
}
