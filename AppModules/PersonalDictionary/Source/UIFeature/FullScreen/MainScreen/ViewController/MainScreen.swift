//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import UIKit

/// View controller Главного экрана.
final class MainScreen: UIViewController {

    private let heading: UILabel
    private let mainWordListViewController: UIViewController
    private let mainNavigator: MainNavigator

    /// Инициализатор.
    /// - Parameters:
    ///  - mainWordListBuilder: билдер вложенной фичи "Главный список слов".
    ///  - mainNavigatorBuilder: билдер вложенной фичи "Контейнер элементов навигации на Главном экране приложения".
    init(heading: String,
         mainWordListBuilder: MainWordListBuilder,
         mainNavigatorBuilder: MainNavigatorBuilder) {
        self.heading = Heading(heading)
        self.mainWordListViewController = mainWordListBuilder.build()
        self.mainNavigator = mainNavigatorBuilder.build()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) are not implemented.")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = UIView()

        initViews()
    }

    // MARK: - Private

    private func initViews() {
        view.backgroundColor = Theme.data.backgroundColor
        layoutHeading()
        layout(wordListViewController: mainWordListViewController, topOffset: 46)
        mainNavigator.appendTo(rootView: view)
    }

    private func layoutHeading() {
        view.addSubview(heading)
        heading.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(14)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(54.5)
        }
    }
}
