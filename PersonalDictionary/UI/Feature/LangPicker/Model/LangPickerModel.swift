//
//  LangPickerModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

protocol LangPickerListener: AnyObject {

    func onLangSelected(_ data: LangSelectorData)
}

protocol LangPickerModel: InitiallyBindable {

    var viewModel: LangPickerViewModel? { get set }

    func sendSelectedLang(_ lang: Lang)
}
