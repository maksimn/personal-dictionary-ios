//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import CoreModule
import UIKit

/// View controller of the Main screen.
final class MainScreen: UIViewController, UISearchControllerDelegate {

    private let mainWordListViewController: UIViewController
    private var mainNavigator: MainNavigator
    private let messageBoxView: UIView
    private let theme: Theme
    private let logger: Logger

    /// Initializer.
    /// - Parameters:
    ///  - mainWordListBuilder: builder for the nested "Main Word List" feature.
    ///  - mainNavigatorBuilder: builder for the nested "Navigation Elements Container on the Main Screen" feature.
    init(title: String,
         mainWordListBuilder: MainWordListBuilder,
         mainNavigatorBuilder: MainNavigatorBuilder,
         messageBoxBuilder: ViewBuilder,
         theme: Theme,
         logger: Logger) {
        self.mainWordListViewController = mainWordListBuilder.build()
        self.mainNavigator = mainNavigatorBuilder.build()
        self.theme = theme
        self.logger = logger
        messageBoxView = messageBoxBuilder.build()
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = title
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) are not implemented.")
    }

    deinit {
        logger.log(dismissedFeatureName: "MainScreen")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = UIView()

        view.backgroundColor = theme.backgroundColor
        layout(childViewController: mainWordListViewController)
        mainNavigator.appendTo(rootView: view)
        view.addSubview(messageBoxView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mainNavigator.viewWillLayoutSubviews()
        subscribeToSearchControllerIfNeeded()
    }

    private var isSubscribedToSearchController = false

    private func subscribeToSearchControllerIfNeeded() {
        guard !isSubscribedToSearchController else { return }

        isSubscribedToSearchController.toggle()

        guard let searchController = navigationItem.searchController else {
            return logger.logWithContext(
                "MainScreen searchController is nil. The events won't be handled.",
                level: .warn
            )
        }

        logger.debug("MainScreen searchController is OK.")

        searchController.delegate = self
    }

    // MARK: - UISearchControllerDelegate

    func willPresentSearchController(_ searchController: UISearchController) {
        self.mainWordListViewController.view.isHidden = true
        mainNavigator.searchTextInputWillPresent()
    }

    func didPresentSearchController(_ searchController: UISearchController) {
        mainNavigator.searchTextInputDidPresent()
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        mainNavigator.searchTextInputWillDismiss()
    }

    func didDismissSearchController(_ searchController: UISearchController) {
        self.mainWordListViewController.view.isHidden = false
        mainNavigator.searchTextInputDidDismiss()
    }
}
