//
//  AppViewController.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 10.08.2022.
//

import CoreModule
import SnapKit
import UIKit

final class MainScreen: UIViewController {

    private let counterView: UIView
    private let showButtonView: UIView
    private let networkIndicatorView: UIView
    private let messageBoxView: UIView
    private let mainListViewController: UIViewController
    private let backButtonFactory: ButtonFactory
    private let theme: Theme

    init(
        mainTitle: String,
        theme: Theme,
        counterBuilder: ViewBuilder,
        showButtonBuilder: ViewBuilder,
        networkIndicatorBuilder: ViewBuilder,
        messageBoxBuilder: ViewBuilder,
        mainListBuilder: ViewControllerBuilder,
        backButtonFactory: ButtonFactory
    ) {
        self.theme = theme
        counterView = counterBuilder.build()
        showButtonView = showButtonBuilder.build()
        networkIndicatorView = networkIndicatorBuilder.build()
        messageBoxView = messageBoxBuilder.build()
        mainListViewController = mainListBuilder.build()
        self.backButtonFactory = backButtonFactory
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = mainTitle
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initViews() {
        view.backgroundColor = theme.backgroundColor
        initCounter()
        initVisibilitySwitch()
        initMainList()
        initNetworkIndicator()
        initBackButton()
        view.addSubview(messageBoxView)
    }

    @objc
    private func onBackButtonTap() {
        dismiss(animated: true, completion: nil)
    }

    private func initCounter() {
        view.addSubview(counterView)
        counterView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(32)
            make.height.equalTo(20)
        }
    }

    private func initVisibilitySwitch() {
        view.addSubview(showButtonView)
        showButtonView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-32)
            make.height.equalTo(20)
        }
    }

    private func initMainList() {
        add(childViewController: mainListViewController)
        mainListViewController.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-20)
            make.bottom.equalTo(view.snp.bottom)
        }
    }

    private func initNetworkIndicator() {
        view.addSubview(networkIndicatorView)
        networkIndicatorView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(14)
            make.centerX.equalTo(view.snp.centerX)
        }
    }

    private func initBackButton() {
        let backButton = backButtonFactory.create()

        backButton.addTarget(self, action: #selector(onBackButtonTap), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
}
