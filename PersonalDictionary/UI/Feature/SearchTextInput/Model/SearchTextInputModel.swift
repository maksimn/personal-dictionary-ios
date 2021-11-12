//
//  SearchTextInputModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

protocol SearchTextInputModel {

    var viewModel: SearchTextInputViewModel? { get set }

    func update(_ searchText: String)
}
