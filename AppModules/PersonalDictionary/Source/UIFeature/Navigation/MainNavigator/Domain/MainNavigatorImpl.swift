//
//  MainNavigatorImpl.swift
//  SuperList
//
//  Created by Maksim Ivanov on 26.02.2022.
//

import CoreModule
import RxCocoa
import RxSwift
import UIKit

/// Реализация контейнера элементов навигации на Главном экране приложения.
final class MainNavigatorImpl: MainNavigator {

    private lazy var navigationItem = navigationItemGetter()

    private let navigationItemGetter: () -> UINavigationItem?
    private let searchTextInputView: UISearchController
    private let navToSearchRouter: NavToSearchRouter
    private let navToNewWordView: UIView
    private let navToFavoritesView: UIView
    private let navToTodoListView: UIView
    private let logger: Logger
    private let disposeBag = DisposeBag()

    /// Инициализатор,
    /// - Parameters:
    ///  - navToFavoritesBuilder: билдер вложенной фичи "Элемент навигации на экран списка избранных слов".
    ///  - navToTodoListBuilder: билдер вложенной фичи "Элемент навигации к приложению TodoList".
    init(
        navigationItemGetter: @escaping () -> UINavigationItem?,
        searchTextInputBuilder: SearchControllerBuilder,
        navToSearchBuilder: NavToSearchBuilder,
        navToNewWordBuilder: ViewBuilder,
        navToFavoritesBuilder: ViewBuilder,
        navToTodoListBuilder: ViewBuilder,
        logger: Logger
    ) {
        self.navigationItemGetter = navigationItemGetter
        self.searchTextInputView = searchTextInputBuilder.build()
        self.navToSearchRouter = navToSearchBuilder.build()
        self.navToNewWordView = navToNewWordBuilder.build()
        self.navToFavoritesView = navToFavoritesBuilder.build()
        self.navToTodoListView = navToTodoListBuilder.build()
        self.logger = logger
        subscribeToSearchTextInput()
    }

    func appendTo(rootView: UIView) {
        addNavToNewWord(rootView)
        addNavToFavorites()
        addNavToTodoList()
    }

    func viewWillLayoutSubviews() {
        navigationItem?.searchController = searchTextInputView
        logSearchTextInputInstallationIfNeeded()
    }

    private func addNavToFavorites() {
        navigationItem?.leftBarButtonItem = UIBarButtonItem(customView: navToFavoritesView)

        logNavToFavoritesFeatureInstallation()
    }

    private func addNavToTodoList() {
        navigationItem?.rightBarButtonItem = UIBarButtonItem(customView: navToTodoListView)

        logNavToTodoListFeatureInstallation()
    }

    private func addNavToNewWord(_ view: UIView) {
        view.addSubview(navToNewWordView)
        navToNewWordView.snp.makeConstraints { make -> Void in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-26)
            make.centerX.equalTo(view)
        }

        logger.log(installedFeatureName: "NavToNewWord")
    }

    private func subscribeToSearchTextInput() {
        searchTextInputView.rx.willDismiss
            .subscribe(onNext: { [weak self] in
                self?.searchTextInputWillDismiss()
            }).disposed(by: disposeBag)

        searchTextInputView.rx.didDismiss
            .subscribe(onNext: { [weak self] in
                self?.searchTextInputDidDismiss()
            }).disposed(by: disposeBag)

        searchTextInputView.rx.willPresent
            .subscribe(onNext: { [weak self] in
                self?.searchTextInputWillPresent()
            }).disposed(by: disposeBag)

        searchTextInputView.rx.didPresent
            .subscribe(onNext: { [weak self] in
                self?.searchTextInputDidPresent()
            }).disposed(by: disposeBag)
    }

    private func searchTextInputWillDismiss() {
        logger.debug("User will dismiss search.")

        navToSearchRouter.dismissSearch()
    }

    private func searchTextInputDidDismiss() {
        logger.debug("User did dismiss search.")

        navToNewWordView.isHidden = false
    }

    private func searchTextInputWillPresent() {
        logger.debug("User will present search.")

        navToNewWordView.isHidden = true
    }

    private func searchTextInputDidPresent() {
        logger.debug("User did present search.")

        navToSearchRouter.presentSearch()
    }

    // MARK: - Logging

    private var isSearchTextInputInstalled = false

    private func logSearchTextInputInstallationIfNeeded() {
        if navigationItem != nil && !isSearchTextInputInstalled {
            isSearchTextInputInstalled.toggle()
            logger.log(installedFeatureName: "SearchTextInput")
        } else if navigationItem == nil {
            logWarningOnNotInstalled("SearchTextInput", warning: "Users won't be able to use Search.")
        }
    }

    private func logNavToFavoritesFeatureInstallation() {
        logFeatureInstallation("NavToFavorites", warning: "Users won't be able to navigate to Favorites Screen.")
    }

    private func logNavToTodoListFeatureInstallation() {
        logFeatureInstallation("NavToTodoList", warning: "Users won't be able to navigate to To-do list.")
    }

    private func logFeatureInstallation(_ feature: String, warning: String) {
        guard navigationItem != nil else {
            return logWarningOnNotInstalled(feature, warning: warning)
        }

        logger.log(installedFeatureName: feature)
    }

    private func logWarningOnNotInstalled(_ feature: String, warning: String) {
        logger.log(
            "Reference to navigation item is NIL, so \(feature) feature cannot be installed. \(warning)",
            level: .warn
        )
    }
}
