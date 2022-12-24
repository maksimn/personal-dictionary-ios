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

    init(
        searchTextInputBuilder: SearchTextInputBuilder,
        searchModePickerBuilder: SearchModePickerBuilder
    ) {
        let searchTextInputGraph = searchTextInputBuilder.build()
        let searchModePickerGraph = searchModePickerBuilder.build()

        navBarView = searchTextInputGraph.uiview
        view = searchModePickerGraph.uiview
    }
}
