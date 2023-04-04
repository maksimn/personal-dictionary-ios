//
//  AppViewController.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 10.08.2022.
//

import SnapKit
import UIKit

final class MainScreen: UIViewController {

    private let counterView: UIView
    private let showButtonView: UIView
    private let networkIndicatorView: UIView
    private let mainListViewController: UIViewController
    private let theme: Theme

    init(
        mainTitle: String,
        theme: Theme,
        counterBuilder: ViewBuilder,
        showButtonBuilder: ViewBuilder,
        networkIndicatorBuilder: ViewBuilder,
        mainListBuilder: ViewControllerBuilder
    ) {
        self.theme = theme
        counterView = counterBuilder.build()
        showButtonView = showButtonBuilder.build()
        networkIndicatorView = networkIndicatorBuilder.build()
        mainListViewController = mainListBuilder.build()
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
    }

    private func initCounter() {
        view.addSubview(counterView)
        counterView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(32)
            make.height.equalTo(20)
        }
    }

    private func initVisibilitySwitch() {
        view.addSubview(showButtonView)
        showButtonView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-32)
            make.height.equalTo(20)
        }
    }

    private func initMainList() {
        add(childViewController: mainListViewController)
        mainListViewController.view.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-20)
            make.bottom.equalTo(view.snp.bottom)
        }
    }

    private func initNetworkIndicator() {
        view.addSubview(networkIndicatorView)
        networkIndicatorView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(14)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
}
