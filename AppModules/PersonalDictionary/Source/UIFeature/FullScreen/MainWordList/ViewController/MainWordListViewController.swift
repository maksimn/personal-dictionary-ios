//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import CoreModule
import UIKit

/// View controller экрана Главного списка слов.
class MainWordListViewController: UIViewController {

    let params: MainWordListViewParams

    let wordListMVVM: WordListMVVM
    let wordListFetcher: WordListFetcher
    let router: MainWordListRouter
    let navToSearchBuilder: NavToSearchBuilder
    let headerBuilder: MainWordListHeaderBuilder
    let coreRouter: CoreRouter?

    let navToNewWordButton = UIButton()
    let routingButton = UIButton()

    /// Инициализатор.
    /// - Parameters:
    ///  - viewParams: параметры представления Главного списка слов.
    ///  - wordListMVVM: MVVM-граф фичи "Список слов".
    ///  - wordListFetcher: источник данных для получения списка слов из хранилища.
    ///  - router: роутер для навигации от Главного списка слов к другим экранам приложения.
    ///  - navToSearchBuilder: билдер фичи "Навигация на экран Поиска".
    ///  - headerBuilder: билдер фичи  "Заголовок главного списка слов".
    ///  - coreRouter: базовый роутер для навигации к другому Продукту/Приложению в супераппе.
    init(viewParams: MainWordListViewParams,
         wordListMVVM: WordListMVVM,
         wordListFetcher: WordListFetcher,
         router: MainWordListRouter,
         navToSearchBuilder: NavToSearchBuilder,
         headerBuilder: MainWordListHeaderBuilder,
         coreRouter: CoreRouter?) {
        self.params = viewParams
        self.wordListMVVM = wordListMVVM
        self.wordListFetcher = wordListFetcher
        self.router = router
        self.navToSearchBuilder = navToSearchBuilder
        self.headerBuilder = headerBuilder
        self.coreRouter = coreRouter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) are not implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initWordListModel()
    }

    @objc
    func onRoutingButtonTap() {
        coreRouter?.navigate()
    }

    @objc
    func navigateToNewWord() {
        router.navigateToNewWord()
    }

    private func initWordListModel() {
        let wordList = wordListFetcher.wordList
        guard let wordListModel = wordListMVVM.model else { return }

        wordListModel.wordList = wordList
        wordListModel.requestTranslationsIfNeededWithin(startPosition: 0,
                                                        endPosition: params.visibleItemMaxCount + 1)
    }
}
