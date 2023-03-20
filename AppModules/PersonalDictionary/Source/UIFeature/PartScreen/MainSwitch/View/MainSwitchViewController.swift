//
//  ViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

final class MainSwitchViewController: UIViewController, MainSwitchView {

    private let presenter: MainSwitchPresenter
    private let mainWordListViewController: UIViewController
    private let searchViewController: UIViewController

    init(initialState: MainScreenState,
         presenter: MainSwitchPresenter,
         mainWordListBuilder: ViewControllerBuilder,
         searchBuilder: ViewControllerBuilder) {
        self.presenter = presenter
        self.mainWordListViewController = mainWordListBuilder.build()
        self.searchViewController = searchBuilder.build()
        super.init(nibName: nil, bundle: nil)

        switch initialState {
        case .main:
            layout(childViewController: mainWordListViewController)
        case .search:
            layout(childViewController: searchViewController)
        case .empty:
            break
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(_ state: MainScreenState) {
        switch state {
        case .main:
            layout(childViewController: mainWordListViewController)
        case .search:
            layout(childViewController: searchViewController)
        case .empty:
            mainWordListViewController.removeFromParentViewController()
            searchViewController.removeFromParentViewController()
        }
    }
}
