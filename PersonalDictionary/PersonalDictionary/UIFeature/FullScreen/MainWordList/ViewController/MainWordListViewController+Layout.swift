//
//  MainWordListContainer+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 08.11.2021.
//

import UIKit

extension MainWordListViewController {

    func initViews() {
        view.backgroundColor = params.styles.backgroundColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.titleView = navToSearchView
        addWordListChildController()
        view.addSubview(navToNewWordButton)
        initNewWordButton()
        initRoutingButton()
        initMyDictionaryLabel()
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

    private func initNewWordButton() {
        navToNewWordButton.setImage(params.staticContent.navToNewWordImage, for: .normal)
        navToNewWordButton.imageView?.contentMode = .scaleAspectFit
        navToNewWordButton.addTarget(self, action: #selector(navigateToNewWord), for: .touchUpInside)
        navToNewWordButton.snp.makeConstraints { make -> Void in
            make.size.equalTo(params.styles.navToNewWordButtonSize)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                .offset(params.styles.navToNewWordButtonBottomOffset)
            make.centerX.equalTo(view)
        }
        if let imageView = navToNewWordButton.imageView {
            imageView.snp.makeConstraints { make -> Void in
                make.edges.equalTo(navToNewWordButton)
            }
        }
    }

    private func initRoutingButton() {
        routingButton.setTitle(params.staticContent.routingButtonTitle, for: .normal)
        routingButton.setTitleColor(.darkGray, for: .normal)
        routingButton.backgroundColor = .clear
        routingButton.layer.cornerRadius = 8
        routingButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        routingButton.addTarget(self, action: #selector(onSuperAppRoutingButtonTap), for: .touchUpInside)
        view.addSubview(routingButton)
        routingButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(21)
            make.right.equalTo(view.snp.right).offset(-10)
        }
    }

    private func initMyDictionaryLabel() {
        myDictionaryLabel.textColor = .black
        myDictionaryLabel.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        myDictionaryLabel.numberOfLines = 1
        myDictionaryLabel.textAlignment = .left
        myDictionaryLabel.text = params.staticContent.heading
        view.addSubview(myDictionaryLabel)
        myDictionaryLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(14)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(34)
        }
    }
}
