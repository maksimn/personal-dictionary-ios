//
//  MainNavigatorImpl.swift
//  SuperList
//
//  Created by Maksim Ivanov on 26.02.2022.
//

import UIKit

final class MainNavigatorImpl: MainNavigator {

     private let navigationController: UINavigationController
     private let navToSearchBuilder: NavToSearchBuilder
     private let navToFavoriteWordListBuilder: NavToFavoriteWordListBuilder
     private let navToNewWordBuilder: NavToNewWordBuilder

    init(navigationController: UINavigationController,
         navToSearchBuilder: NavToSearchBuilder,
         navToFavoriteWordListBuilder: NavToFavoriteWordListBuilder,
         navToNewWordBuilder: NavToNewWordBuilder) {
        self.navigationController = navigationController
        self.navToSearchBuilder = navToSearchBuilder
        self.navToFavoriteWordListBuilder = navToFavoriteWordListBuilder
        self.navToNewWordBuilder = navToNewWordBuilder
    }

    func addNavigationViews() {
        initNavToSearch()
        initNavToFavoriteWordList()
        initNavToNewWord()
    }

    private func initNavToSearch() {
        let navToSearchView = navToSearchBuilder.build()
        let navigationItem = navigationController.topViewController?.navigationItem

        navigationItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem?.titleView = navToSearchView
    }

    private func initNavToFavoriteWordList() {
        guard let view = view else { return }
        let navToFavoriteWordListView = navToFavoriteWordListBuilder.build()

        view.addSubview(navToFavoriteWordListView)
        navToFavoriteWordListView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.size.equalTo(CGSize(width: 60, height: 50))
        }
    }

    private func initNavToNewWord() {
        guard let view = view else { return }
        let navView = navToNewWordBuilder.build()

        view.addSubview(navView)
        navView.snp.makeConstraints { make -> Void in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-26)
            make.centerX.equalTo(view)
        }
    }

    private var view: UIView? {
        navigationController.topViewController?.view
    }
}
