//
//  LangPickerBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

protocol LangPickerBuilder {

    func build(with initLang: Lang,
               selectedLangType: SelectedLangType,
               listener: LangPickerListener?) -> LangPickerMVVM
}
