//
//  SearchTextInputViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

final class SearchTextInputViewModelImpl: SearchTextInputViewModel {

    private unowned let view: SearchTextInputView
    private let model: SearchTextInputModel

    init(model: SearchTextInputModel, view: SearchTextInputView) {
        self.model = model
        self.view = view
    }
}
