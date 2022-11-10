//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import UIKit

/// Параметры представления Главного списка слов.
struct MainWordListViewParams {

    /// Текст заголовка
    let heading: String

    /// Максимальное количество видимых элементов (слов) на данном экране
    let visibleItemMaxCount: Int
}

/// View controller экрана Главного списка слов.
final class MainWordListViewController: UIViewController {

    private let params: MainWordListViewParams

    private let wordListGraph: WordListGraph
    private let wordListFetcher: WordListFetcher
    private let mainNavigator: MainNavigator

    private lazy var heading = Heading(params.heading)

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

    // MARK: - Lifecycle

    override func loadView() {
        view = UIView()

        initViews()
        mainNavigator.appendTo(rootView: view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initWordListModel()
    }

    // MARK: - Private

    private func initWordListModel() {
        let wordList = wordListFetcher.wordList
        guard let wordListModel = wordListGraph.model else { return }

        wordListModel.wordList = wordList
        wordListModel.requestTranslationsIfNeededWithin(startPosition: 0,
                                                        endPosition: params.visibleItemMaxCount + 1)
    }

    private func initViews() {
        view.backgroundColor = Theme.data.backgroundColor
        layoutHeading()
        layout(wordListViewController: wordListGraph.viewController)
    }

    private func layoutHeading() {
        view.addSubview(heading)
        heading.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(14)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(54.5)
        }
    }
}
