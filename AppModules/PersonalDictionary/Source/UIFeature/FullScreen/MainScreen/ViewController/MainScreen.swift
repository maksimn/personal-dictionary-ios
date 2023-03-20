//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import CoreModule
import RxSwift
import UIKit

/// View controller Главного экрана.
final class MainScreen: UIViewController {

    private let mainWordListViewController: UIViewController
    private let mainNavigator: MainNavigator
    private let searchController: UISearchController
    private let searchViewController: UIViewController
    private let logger: SLogger
    private let theme: Theme
    private let disposeBag = DisposeBag()

    private var state = MainScreenState.main

    /// - Parameters:
    ///  - mainWordListBuilder: билдер вложенной фичи "Главный список слов".
    ///  - mainNavigatorBuilder: билдер вложенной фичи "Контейнер элементов навигации на Главном экране приложения".
    init(
        heading: String,
        mainWordListBuilder: ViewControllerBuilder,
        mainNavigatorBuilder: MainNavigatorBuilder,
        searchTextInputBuilder: SearchControllerBuilder,
        searchBuilder: ViewControllerBuilder,
        mainScreenStateStream: MainScreenStateStream,
        logger: SLogger,
        theme: Theme
    ) {
        self.mainWordListViewController = mainWordListBuilder.build()
        self.mainNavigator = mainNavigatorBuilder.build()
        self.searchController = searchTextInputBuilder.build()
        self.searchViewController = searchBuilder.build()
        self.logger = logger
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = heading
        mainScreenStateStream.mainScreenState.subscribe(onNext: { [weak self] state in
            self?.onNext(mainScreenState: state)
        }).disposed(by: disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) are not implemented.")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = UIView()

        initViews()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationItem.searchController = searchController
    }

    // MARK: - Private

    private func onNext(mainScreenState: MainScreenState) {
        logger.log("Received mainScreenState = \(mainScreenState) from the MAIN SCREEN STATE model stream.")

        if mainScreenState != state && mainScreenState == .search {
            mainWordListViewController.removeFromParentViewController()
            layout(wordListViewController: searchViewController, topOffset: 0)
        } else if mainScreenState != state && mainScreenState == .main {
            searchViewController.removeFromParentViewController()
            layout(wordListViewController: mainWordListViewController, topOffset: 0)
        }

        state = mainScreenState
    }

    private func initViews() {
        view.backgroundColor = theme.backgroundColor
        layout(wordListViewController: mainWordListViewController, topOffset: 0)
        mainNavigator.appendTo(rootView: view)
    }
}
