//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import CoreModule
import UIKit

/// View controller of the Main Word List.
final class MainWordListViewController: UIViewController, ObservationLoopLegacy {

    private let viewModel: MainWordListViewModel
    private let wordListGraph: WordListGraph

    /// Initializer.
    /// - Parameters:
    ///  - wordListBuilder: builder of the nested "Word List" feature.
    init(
        viewModel: MainWordListViewModel,
        wordListBuilder: WordListBuilder
    ) {
        self.viewModel = viewModel
        self.wordListGraph = wordListBuilder.build()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) are not implemented.")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = UIView()

        layout(wordListView: wordListGraph.view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        startObservationLoop { [weak self] in
            guard let self = self else { return }
            let wordListViewModel = self.wordListGraph.viewModel

            wordListViewModel.wordList = viewModel.wordList
        }

        viewModel.fetch()
    }
}
