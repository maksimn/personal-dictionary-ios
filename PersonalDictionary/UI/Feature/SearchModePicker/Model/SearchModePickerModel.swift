//
//  SearchModeModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

enum SearchMode { case bySourceWord, byTranslation }

protocol SearchModePickerListener: AnyObject {

    func onSearchModeChanged(_ searchMode: SearchMode)
}

protocol SearchModePickerModel: AnyObject {

    var viewModel: SearchModePickerViewModel? { get set }

    var listener: SearchModePickerListener? { get set }

    var searchMode: SearchMode { get }

    func update(_ searchMode: SearchMode)
}
