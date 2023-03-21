//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import UIKit

/// View controller Главного экрана.
final class MainScreen: UIViewController {

    private let mainWordListViewController: UIViewController
    private let mainNavigator: MainNavigator
    private let theme: Theme

    /// Инициализатор.
    /// - Parameters:
    ///  - mainWordListBuilder: билдер вложенной фичи "Главный список слов".
    ///  - mainNavigatorBuilder: билдер вложенной фичи "Контейнер элементов навигации на Главном экране приложения".
    init(heading: String,
         mainWordListBuilder: MainWordListBuilder,
         mainNavigatorBuilder: MainNavigatorBuilder,
         theme: Theme) {
        self.mainWordListViewController = mainWordListBuilder.build()
        self.mainNavigator = mainNavigatorBuilder.build()
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = heading
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) are not implemented.")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = UIView()

        view.backgroundColor = theme.backgroundColor
        layout(childViewController: mainWordListViewController)
        mainNavigator.appendTo(rootView: view)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mainNavigator.viewWillLayoutSubviews()
    }
}
