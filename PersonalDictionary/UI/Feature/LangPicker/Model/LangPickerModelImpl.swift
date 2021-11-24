//
//  LangPickerModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import Foundation

final class LangPickerModelImpl: LangPickerModel {

    weak var viewModel: LangPickerViewModel?

    private(set) var data: LangSelectorData {
        didSet {
            viewModel?.langSelectorData = data
        }
    }

    private weak var listener: LangPickerListener?

    init(data: LangSelectorData, listener: LangPickerListener?) {
        self.data = data
        self.listener = listener
    }

    func bindInitially() {
        viewModel?.langSelectorData = data
    }

    func sendSelectedLang(_ lang: Lang) {
        let newData = LangSelectorData(allLangs: data.allLangs,
                                       selectedLang: lang,
                                       selectedLangType: data.selectedLangType)
        listener?.onLangSelected(newData)
    }
}
