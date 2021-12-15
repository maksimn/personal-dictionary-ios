//
//  LangPickerModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import Foundation

final class LangPickerModelImpl: LangPickerModel {

    var data: LangSelectorData? {
        didSet {
            viewModel?.langSelectorData = data
        }
    }

    weak var listener: LangPickerListener?

    weak var viewModel: LangPickerViewModel?

    func sendSelectedLang(_ lang: Lang) {
        guard let langType = data?.selectedLangType else { return }

        listener?.onLangSelected(LangSelectorData(selectedLang: lang,
                                                  selectedLangType: langType))
    }
}
