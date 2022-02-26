//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import CoreModule
import UIKit

/// View controller экрана Главного списка слов.
final class MainWordListViewController: UIViewController {

    let params: MainWordListViewParams

    let wordListMVVM: WordListMVVM
    let wordListFetcher: WordListFetcher
    let coreRouter: CoreRouter?
    let mainNavigator: MainNavigator

    let headingLabel = UILabel()
    let routingButton = UIButton()

    /// Инициализатор.
    /// - Parameters:
    ///  - viewParams: параметры представления Главного списка слов.
    ///  - wordListMVVM: MVVM-граф фичи "Список слов".
    ///  - wordListFetcher: источник данных для получения списка слов из хранилища.
    ///  - coreRouter: базовый роутер для навигации к другому Продукту/Приложению в супераппе.
    ///  - mainNavigatorBuilder:
    init(viewParams: MainWordListViewParams,
         wordListBuilder: WordListBuilder,
         wordListFetcher: WordListFetcher,
         coreRouter: CoreRouter?,
         mainNavigatorBuilder: MainNavigatorBuilder) {
        self.params = viewParams
        self.wordListMVVM = wordListBuilder.build()
        self.wordListFetcher = wordListFetcher
        self.coreRouter = coreRouter
        self.mainNavigator = mainNavigatorBuilder.build()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) are not implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        mainNavigator.addNavigationViews()
        initWordListModel()
    }

    @objc
    func onRoutingButtonTap() {
        coreRouter?.navigate()
    }

    private func initWordListModel() {
        let wordList = wordListFetcher.wordList
        guard let wordListModel = wordListMVVM.model else { return }

        wordListModel.wordList = wordList
        wordListModel.requestTranslationsIfNeededWithin(startPosition: 0,
                                                        endPosition: params.visibleItemMaxCount + 1)
    }
}
