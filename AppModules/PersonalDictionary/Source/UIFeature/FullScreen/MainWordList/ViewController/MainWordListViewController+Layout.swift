//
//  MainWordListContainer+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 08.11.2021.
//

import UIKit

/// Лэйаут экрана Главного списка слов.
extension MainWordListViewController {

    func initViews() {
        view.backgroundColor = Theme.standard.backgroundColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.titleView = navToSearchBuilder.build()
        addWordListChildController()
        initRoutingButton()
        initHeaderView()
        initHeadingLabel()
    }

    private func addWordListChildController() {
        let wordListViewController = wordListMVVM.viewController
        let wordListParentView = UIView()

        view.addSubview(wordListParentView)
        wordListParentView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(46)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        wordListParentView.addSubview(wordListViewController.view)
        addChild(wordListViewController)
        wordListViewController.didMove(toParent: self)
        wordListViewController.view.snp.makeConstraints { make -> Void in
            make.edges.equalTo(wordListParentView)
        }
    }

    

    private func initRoutingButton() {
        routingButton.setTitle(params.routingButtonTitle, for: .normal)
        routingButton.setTitleColor(.darkGray, for: .normal)
        routingButton.backgroundColor = .clear
        routingButton.layer.cornerRadius = 8
        routingButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        routingButton.addTarget(self, action: #selector(onRoutingButtonTap), for: .touchUpInside)
        view.addSubview(routingButton)
        routingButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(21)
            make.right.equalTo(view.snp.right).offset(-10)
        }
    }

    private func initHeaderView() {
        let headerView = headerBuilder.build()

        view.addSubview(headerView)
        headerView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(routingButton.snp.left)
            make.height.equalTo(50)
        }
    }

    private func initHeadingLabel() {
        headingLabel.textColor = .black
        headingLabel.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        headingLabel.numberOfLines = 1
        headingLabel.textAlignment = .left
        headingLabel.text = params.heading
        view.addSubview(headingLabel)
        headingLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(14)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(54.5)
        }
    }
}
