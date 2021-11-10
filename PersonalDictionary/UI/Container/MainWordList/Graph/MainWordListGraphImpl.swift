//
//  MainWordListGraphImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

final class MainWordListGraphImpl: MainWordListGraph {

    private let container: MainWordListContainer

    let mainWordListViewParams = MainWordListViewParams(
        staticContent: MainWordListStaticContent(navToNewWordImage: UIImage(named: "icon-plus")!),
        styles: MainWordListStyles(
            navToSearchViewSize: CGSize(width: UIScreen.main.bounds.width - 32, height: 44),
            navToNewWordButtonSize: CGSize(width: 44, height: 44),
            navToNewWordButtonBottomOffset: -26)
    )

    let navigationController: UINavigationController?

    init(wordListBuilder: WordListBuilder,
         wordListFetcher: WordListFetcher,
         navigationController: UINavigationController,
         mainWordListBuilder: MainWordListBuilder) {
        self.navigationController = navigationController
        let visibleItemMaxCount = Int(ceil(UIScreen.main.bounds.height / WordItemCell.height))
        let router = RouterImpl(navigationController: navigationController,
                                builder: mainWordListBuilder)

        container = MainWordListContainer(viewParams: mainWordListViewParams,
                                          wordListMVVM: wordListBuilder.build(),
                                          wordListFetcher: wordListFetcher,
                                          router: router,
                                          visibleItemMaxCount: visibleItemMaxCount)

        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController.setViewControllers([container], animated: false)
    }
}
