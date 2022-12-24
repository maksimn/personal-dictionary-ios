//
//  SearchTextInputViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

struct SearchInputData {
    var text: String
    var mode: SearchMode
}

protocol SearchInputListener: AnyObject {

    func onSeachInputChanged(_ data: SearchInputData)
}

protocol SearchInputModel: AnyObject, SearchTextInputListener, SearchModePickerListener {

    var listener: SearchInputListener? { get set }
}
