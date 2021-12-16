//
//  SearchModeViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

protocol SearchModePickerViewModel: AnyObject {

    var searchMode: SearchMode? { get set }

    func update(_ searchMode: SearchMode)
}
