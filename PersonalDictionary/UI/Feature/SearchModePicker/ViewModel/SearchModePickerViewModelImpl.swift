//
//  SearchModeViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

final class SearchModePickerViewModelImpl: SearchModePickerViewModel {

    private weak var view: SearchModePickerView?
    private let model: SearchModePickerModel

    init(model: SearchModePickerModel, view: SearchModePickerView) {
        self.model = model
        self.view = view
    }

    var searchMode: SearchMode? {
        didSet {
            guard let searchMode = searchMode else { return }
            view?.set(searchMode)
        }
    }

    func update(_ searchMode: SearchMode) {
        model.update(searchMode)
    }
}
