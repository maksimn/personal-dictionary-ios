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

    let wordListGraph: WordListGraph
    let wordListFetcher: WordListFetcher
    let mainNavigator: MainNavigator

    lazy var heading = Heading(params.heading)

    /// Инициализатор.
    /// - Parameters:
    ///  - viewParams: параметры представления Главного списка слов.
    ///  - wordListBuilder: билдер вложенной фичи "Список слов".
    ///  - wordListFetcher: источник данных для получения списка слов из хранилища.
    ///  - mainNavigatorBuilder: билдер вложенной фичи "Контейнер элементов навигации на Главном экране приложения".
    init(viewParams: MainWordListViewParams,
         wordListBuilder: WordListBuilder,
         wordListFetcher: WordListFetcher,
         mainNavigatorBuilder: MainNavigatorBuilder) {
        self.params = viewParams
        self.wordListGraph = wordListBuilder.build()
        self.wordListFetcher = wordListFetcher
        self.mainNavigator = mainNavigatorBuilder.build()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) are not implemented.")
    }

    override func loadView() {
        view = UIView()

        initViews()
        mainNavigator.appendTo(rootView: view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initWordListModel()
    }

    private func initWordListModel() {
        let wordList = wordListFetcher.wordList
        guard let wordListModel = wordListGraph.model else { return }

        wordListModel.wordList = wordList
        wordListModel.requestTranslationsIfNeededWithin(startPosition: 0,
                                                        endPosition: params.visibleItemMaxCount + 1)
    }
}
