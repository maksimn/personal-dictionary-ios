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
    private var mainNavigator: MainNavigator
    private let messageBoxView: UIView
    private let theme: Theme
    private let logger: Logger

    private let disposeBag = DisposeBag()

    /// Инициализатор.
    /// - Parameters:
    ///  - mainWordListBuilder: билдер вложенной фичи "Главный список слов".
    ///  - mainNavigatorBuilder: билдер вложенной фичи "Контейнер элементов навигации на Главном экране приложения".
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

        searchController.rx.willPresent
            .subscribe(onNext: { [weak self] in
                self?.mainWordListViewController.view.isHidden = true
            }).disposed(by: disposeBag)

        searchController.rx.didDismiss
            .subscribe(onNext: { [weak self] in
                self?.mainWordListViewController.view.isHidden = false
            }).disposed(by: disposeBag)
    }
}
