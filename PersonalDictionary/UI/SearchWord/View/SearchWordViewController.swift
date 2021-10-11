//
//  SearchWordViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.10.2021.
//

import UIKit

final class SearchWordViewController: WordListViewController, SearchWordView {

    override func viewDidLoad() {
        super.viewDidLoad()
        rearrangeViews()
    }
}
