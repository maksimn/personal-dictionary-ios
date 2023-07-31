//
//  LoggableMainNavigator.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 31.07.2023.
//

import CoreModule
import RxSwift
import UIKit

/// Logic of logging of the MainNavigator feature.
/// Implemented using the Decorator pattern.
final class MainNavigatorLog: MainNavigator {

    private let mainNavigator: MainNavigator
    private let logger: Logger
    private let navigationItemGetter: () -> UINavigationItem?
    private weak var navigationItem: UINavigationItem?
    private weak var searchTextInputView: UISearchController?
    private var isSearchTextInputInstalled = false
    private let disposeBag = DisposeBag()

    init(
        mainNavigator: MainNavigator,
        navigationItemGetter: @escaping () -> UINavigationItem?,
        searchTextInputView: UISearchController,
        logger: Logger
    ) {
        self.mainNavigator = mainNavigator
        self.navigationItemGetter = navigationItemGetter
        self.searchTextInputView = searchTextInputView
        self.logger = logger
        subscribeToSearchTextInput()
    }

    deinit {
        logger.log(dismissedFeatureName: "MainNavigatorImpl")
    }

    func appendTo(rootView: UIView) {
        logger.log(installedFeatureName: "MainNavigatorImpl")
        initNavigationItemIfNeeded()

        mainNavigator.appendTo(rootView: rootView)

        logNavToFavoritesFeatureInstallation()
        logNavToTodoListFeatureInstallation()
        logger.log(installedFeatureName: "NavToNewWord")
    }

    func viewWillLayoutSubviews() {
        initNavigationItemIfNeeded()
        mainNavigator.viewWillLayoutSubviews()
        logSearchTextInputInstallationIfNeeded()
    }

    private func initNavigationItemIfNeeded() {
        if navigationItem == nil {
            navigationItem = navigationItemGetter()
        }
    }

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

    private func subscribeToSearchTextInput() {
        searchTextInputView?.rx.willDismiss
            .subscribe(onNext: { [weak self] in
                self?.logger.debug("User will dismiss search.")
            }).disposed(by: disposeBag)

        searchTextInputView?.rx.didDismiss
            .subscribe(onNext: { [weak self] in
                self?.logger.debug("User did dismiss search.")
            }).disposed(by: disposeBag)

        searchTextInputView?.rx.willPresent
            .subscribe(onNext: { [weak self] in
                self?.logger.debug("User will present search.")
            }).disposed(by: disposeBag)

        searchTextInputView?.rx.didPresent
            .subscribe(onNext: { [weak self] in
                self?.logger.debug("User did present search.")
            }).disposed(by: disposeBag)
    }
}
