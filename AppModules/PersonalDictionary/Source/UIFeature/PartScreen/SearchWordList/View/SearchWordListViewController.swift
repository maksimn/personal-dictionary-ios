//
//  ViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import CoreModule
import UIKit

final class SearchWordListViewController: UIViewController, ObservationLoopLegacy {

    private let viewModel: SearchWordListViewModel

    private let wordListGraph: WordListGraph

    private let centerLabel: UILabel

    /// - Parameters:
    ///  - viewModel: view model.
    ///  - wordListBuilder: builder of the nested "Word List" feature.
    ///  - labelText: text for the search result.
    init(
        viewModel: SearchWordListViewModel,
        wordListBuilder: WordListBuilder,
        labelText: String,
        theme: Theme
    ) {
        self.viewModel = viewModel
        self.wordListGraph = wordListBuilder.build()
        self.centerLabel = secondaryText(labelText, theme)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = UIView()

        initViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startObservationLoop { [weak self] in
            guard let self = self else { return }
            let data = self.viewModel.searchResult
            let wordListViewModel = self.wordListGraph.viewModel

            self.centerLabel.isHidden = !(data.searchState == .fulfilled && data.foundWordList.count == 0)
            wordListViewModel.wordList = data.foundWordList
        }
    }

    // MARK: - Layout

    private func initViews() {
        layout(wordListView: wordListGraph.view)
        initCenterLabel()
    }

    private func initCenterLabel() {
        view.addSubview(centerLabel)
        centerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(view).offset(-20)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
    }
}
