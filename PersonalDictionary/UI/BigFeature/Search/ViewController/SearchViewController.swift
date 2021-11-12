//
//  SearchViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

final class SearchViewController: UIViewController {

    private let searchTextInputMVVM: SearchTextInputMVVM

    init(_ searchTextInputBuilder: SearchTextInputBuilder) {
        searchTextInputMVVM = searchTextInputBuilder.build()
        super.init(nibName: nil, bundle: nil)
        navigationItem.titleView = searchTextInputMVVM.uiview
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
    }
}
