//
//  ViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import RxSwift
import UIKit

final class SearchViewController: UIViewController {

    private let viewModel: SearchViewModel
    private let searchModePickerView: UIView
    private let wordListGraph: WordListGraph
    private let centerLabel: UILabel
    private let theme: Theme
    private let searchModePickerViewHeight: CGFloat = 46
    private let disposeBag = DisposeBag()

    /// - Parameters:
    ///  - viewModel: модель представления.
    ///  - wordListBuilder: билдер вложенной фичи "Список слов".
    ///  - labelText: текст для результата поиска.
    init(
        viewModel: SearchViewModel,
        searchModePickerBuilder: ViewBuilder,
        wordListBuilder: WordListBuilder,
        labelText: String,
        theme: Theme
    ) {
        self.viewModel = viewModel
        self.searchModePickerView = searchModePickerBuilder.build()
        self.wordListGraph = wordListBuilder.build()
        self.centerLabel = SecondaryText(labelText, theme)
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = UIView()

        view.backgroundColor = theme.backgroundColor
        initViews()
        bindToViewModel()
    }

    // MARK: - Private

    private func bindToViewModel() {
        viewModel.searchResult.subscribe(onNext: { [weak self] data in
            guard let wordListViewModel = self?.wordListGraph.viewModel else { return }

            self?.centerLabel.isHidden = !(data.searchState == .fulfilled && data.foundWordList.count == 0)
            wordListViewModel.wordList.accept(data.foundWordList)
        }).disposed(by: disposeBag)
    }

    private func initViews() {
        initSearchModePicker()
        layout(wordListView: wordListGraph.view, topOffset: searchModePickerViewHeight)
        layout(centerLabel: centerLabel)
    }

    private func initSearchModePicker() {
        view.addSubview(searchModePickerView)
        searchModePickerView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(searchModePickerViewHeight)
        }
    }
}
