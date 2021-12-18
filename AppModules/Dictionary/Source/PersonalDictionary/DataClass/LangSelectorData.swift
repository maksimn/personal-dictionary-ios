//
//  LangSelectorData.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

enum SelectedLangType { case source, target }

struct LangSelectorData {
    let selectedLang: Lang
    let selectedLangType: SelectedLangType
}
