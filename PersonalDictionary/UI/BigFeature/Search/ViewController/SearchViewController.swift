//
//  SearchViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

final class SearchViewController: UIViewController, SearchTextInputListener {

    private var searchTextInputMVVM: SearchTextInputMVVM?
    private let searchEngine: SearchEngine

    init(_ searchTextInputBuilder: SearchTextInputBuilder,
         _ searchEngineBuilder: SearchEngineBuilder) {
        searchEngine = searchEngineBuilder.build()
        super.init(nibName: nil, bundle: nil)
        searchTextInputMVVM = searchTextInputBuilder.build(self)
        navigationItem.titleView = searchTextInputMVVM?.uiview
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
    }

    func onSearchTextChange(_ searchText: String) {
        searchEngine.findItems(contain: searchText, completion: { foundWordItems in
            print("foundWordItems.count = \(foundWordItems.count)")
        })
    }
}
