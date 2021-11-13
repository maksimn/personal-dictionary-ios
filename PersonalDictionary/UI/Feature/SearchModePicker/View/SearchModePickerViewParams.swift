//
//  SearchModePickerViewParams.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

struct SearchModePickerStaticContent {
    let searchByLabelText: String
    let sourceWordText: String
    let translationText: String
}

struct SearchModePickerStyles {

}

typealias SearchModePickerViewParams = ViewParams<SearchModePickerStaticContent, SearchModePickerStyles>
