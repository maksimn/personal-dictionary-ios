//
//  LangPickerViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

final class LangPickerViewModelImpl: LangPickerViewModel {

    private unowned let view: LangPickerView
    private let model: LangPickerModel

    init(model: LangPickerModel, view: LangPickerView) {
        self.model = model
        self.view = view
    }

    private static let empty = LangSelectorData(allLangs: [],
                                                lang: Lang(id: Lang.Id(raw: -1), name: "", shortName: ""),
                                                isSourceLang: false)

    var langSelectorData: LangSelectorData = empty {
        didSet {
            view.set(langSelectorData: langSelectorData)
        }
    }

    func sendSelectedLang(_ lang: Lang) {
        model.sendSelectedLang(lang)
    }
}
