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
}
