//
//  LangPickerViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

protocol LangPickerViewModel: AnyObject {

    var langSelectorData: LangSelectorData? { get set }

    func sendSelectedLang(_ lang: Lang)
}
