//
//  LangPickerModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

final class LangPickerModelImpl: LangPickerModel {

    var viewModel: LangPickerViewModel?

    private(set) var data: LangSelectorData

    init(data: LangSelectorData) {
        self.data = data
    }
}
