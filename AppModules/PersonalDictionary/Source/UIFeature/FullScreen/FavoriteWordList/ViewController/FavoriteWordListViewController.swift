//
//  FavoriteWordListViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

/// View controller экрана.
final class FavoriteWordListViewController: UIViewController {

   init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = Theme.standard.backgroundColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
