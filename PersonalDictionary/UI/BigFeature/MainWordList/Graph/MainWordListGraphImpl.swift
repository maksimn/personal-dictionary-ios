//
//  MainWordListGraphImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

final class MainWordListGraphImpl: MainWordListGraph {

    private let controller: MainWordListViewController

    let navigationController: UINavigationController?

    init(viewParams: MainWordListViewParams,
         wordListBuilder: WordListBuilder,
         wordListFetcher: WordListFetcher,
         navigationController: UINavigationController,
         newWordBuilder: NewWordBuilder,
         searchBuilder: SearchBuilder,
         wordItemStream: WordItemStream) {
        self.navigationController = navigationController
        let visibleItemMaxCount = Int(ceil(UIScreen.main.bounds.height / WordItemCell.height))
        let router = MainWordListRouterImpl(navigationController: navigationController,
                                            newWordBuilder: newWordBuilder,
                                            searchBuilder: searchBuilder)

        controller = MainWordListViewController(viewParams: viewParams,
                                                wordListMVVM: wordListBuilder.build(),
                                                wordListFetcher: wordListFetcher,
                                                router: router,
                                                visibleItemMaxCount: visibleItemMaxCount,
                                                wordItemStream: wordItemStream)

        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController.setViewControllers([controller], animated: false)
    }
}
