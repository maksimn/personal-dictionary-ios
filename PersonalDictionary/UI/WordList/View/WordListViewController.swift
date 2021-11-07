//
//  ViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

class WordListViewController: UIViewController, WordListView {

    var viewModel: WordListViewModel?

    let params: WordListViewParams

    let searchBar = UISearchBar()
    let tableView = UITableView()
    let newWordButton = UIButton()
    let navigateToSearchButton = UIButton()

    lazy var tableDataSource: WordTableDataSource = {
        WordTableDataSource(tableView: tableView, data: WordListData(wordList: [], changedItemPosition: nil))
    }()

    lazy var tableActions: WordTableDelegate = {
        WordTableDelegate(onDeleteTap: { [weak self] position in
                            self?.onDeleteWordTap(position)
                          },
                          deleteActionViewParams: DeleteActionViewParams(
                            staticContent: params.staticContent.deleteAction,
                            styles: params.styles.deleteAction
                          )
        )
    }()

    init(params: WordListViewParams) {
        self.params = params
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        viewModel?.fetchDataFromModel()
    }

    // MARK: - WordListView

    func set(_ wordListData: WordListData) {
        tableDataSource.data = wordListData
    }

    func set(wordList: [WordItem]) {}

    func addNewRowToList() {}

    func updateRowAt(_ position: Int) {}

    func removeRowAt(_ position: Int) {}

    func reloadList() {}

    // MARK: - User Action Handlers

    @objc
    func onDeleteWordTap(_ position: Int) {
        let item = tableDataSource.data.wordList[position]

        viewModel?.remove(item, position)
    }

    @objc
    func onNewWordButtonTap() {
        viewModel?.navigateToNewWord()
    }

    @objc
    func onNavigateToSearchButtonTap() {
        viewModel?.navigateToSearch()
    }
}
