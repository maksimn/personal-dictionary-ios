//
//  SearchModeView.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

protocol SearchModePickerView: AnyObject {

    var viewModel: SearchModePickerViewModel? { get set }

    func set(_ searchMode: SearchMode)
}
