//
//  LangPickerView.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

protocol LangPickerView: AnyObject {

    var viewModel: LangPickerViewModel? { get set }

    func set(langSelectorData: LangSelectorData)
}
