//
//  SearchModeModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

final class SearchModePickerModelImpl: SearchModePickerModel, InitiallyBindable {

    weak var viewModel: SearchModePickerViewModel?
    weak var listener: SearchModePickerListener?

    private(set) var searchMode: SearchMode {
        didSet {
            viewModel?.searchMode = searchMode
        }
    }

    init(searchMode: SearchMode, listener: SearchModePickerListener) {
        self.searchMode = searchMode
        self.listener = listener
    }

    func bindInitially() {
        viewModel?.searchMode = searchMode
    }

    func update(_ searchMode: SearchMode) {
        self.searchMode = searchMode
        listener?.onSearchModeChanged(searchMode)
    }
}
