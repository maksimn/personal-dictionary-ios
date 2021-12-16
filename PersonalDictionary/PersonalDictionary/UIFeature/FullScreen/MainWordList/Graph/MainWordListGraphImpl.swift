//
//  MainWordListGraphImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

final class MainWordListGraphImpl: MainWordListGraph {

    weak var navigationController: UINavigationController?

    init(viewParams: MainWordListViewParams,
         wordListBuilder: WordListBuilder,
         wordListFetcher: WordListFetcher,
         newWordBuilder: NewWordBuilder,
         searchBuilder: SearchBuilder,
         superAppRouter: SuperAppRouter?) {
        let navigationController = UINavigationController()
        let router = MainWordListRouterImpl(navigationController: navigationController,
                                            newWordBuilder: newWordBuilder,
                                            searchBuilder: searchBuilder)

        let controller = MainWordListViewController(viewParams: viewParams,
                                                    wordListMVVM: wordListBuilder.build(),
                                                    wordListFetcher: wordListFetcher,
                                                    router: router,
                                                    superAppRouter: superAppRouter)

        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController.setViewControllers([controller], animated: false)
        self.navigationController = navigationController
    }
}
