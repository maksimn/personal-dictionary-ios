//
//  SearchTextInputMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

final class SearchInputGraphImpl: SearchInputGraph {

    let navBarView: UIView

    let view: UIView

    let model: SearchInputModel

    init(
        searchTextInputBuilder: SearchTextInputBuilder,
        searchModePickerBuilder: SearchModePickerBuilder
    ) {
        let searchTextInputGraph = searchTextInputBuilder.build()
        let searchModePickerGraph = searchModePickerBuilder.build()

        let searchInputModel = SearchInputModelImpl()

        searchTextInputGraph.viewModel?.listener = searchInputModel
        searchModePickerGraph.viewModel?.listener = searchInputModel

        navBarView = searchTextInputGraph.uiview
        view = searchModePickerGraph.uiview
        model = searchInputModel
    }
}
