//
//  LangPickerModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

protocol LangPickerListener: AnyObject {

    func onLangSelected(_ data: LangSelectorData)
}

protocol LangPickerModel: AnyObject {

    var data: LangSelectorData? { get set }

    var listener: LangPickerListener? { get set }

    func sendSelectedLang(_ lang: Lang)
}
