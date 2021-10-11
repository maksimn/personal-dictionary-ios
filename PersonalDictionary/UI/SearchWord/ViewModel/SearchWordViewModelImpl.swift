//
//  SearchWordViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.10.2021.
//

final class SearchWordViewModelImpl: SearchWordViewModel {

    private unowned let view: SearchWordView
    private let model: SearchWordModel

    init(model: SearchWordModel, view: SearchWordView) {
        self.model = model
        self.view = view
    }
}
