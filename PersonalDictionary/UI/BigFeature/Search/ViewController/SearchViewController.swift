//
//  SearchViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

final class SearchViewController: UIViewController {

    init(_ searchTextInputBuilder: SearchTextInputBuilder) {
        super.init(nibName: nil, bundle: nil)
        navigationItem.titleView = searchTextInputBuilder.build().uiview
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
    }
}
