//
//  SearchTextInputModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

protocol SearchTextInputListener: AnyObject {

    func onSearchTextChange(_ searchText: String)
}

protocol SearchTextInputModel: AnyObject {

    var viewModel: SearchTextInputViewModel? { get set }

    var listener: SearchTextInputListener? { get set }

    var searchText: String { get }

    func update(_ searchText: String)
}
