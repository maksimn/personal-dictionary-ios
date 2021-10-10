//
//  ViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

struct WordListViewStaticContent {
    let newWordButtonImage: UIImage
    let deleteAction: DeleteActionStaticContent
}

struct WordListViewStyles {
    let backgroundColor: UIColor
    let deleteAction: DeleteActionStyles
}

class WordListViewController: UIViewController, WordListView {

    var viewModel: WordListViewModel?

    let staticContent: WordListViewStaticContent
    let styles: WordListViewStyles

    let tableView = UITableView()
    let tableController = WordTableController()

    let newWordButton = UIButton()

    init(staticContent: WordListViewStaticContent, styles: WordListViewStyles) {
        self.staticContent = staticContent
        self.styles = styles
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

    @objc
    func onNewWordButtonTap() {
        let newWordMVVM = NewWordMVVMImpl(langRepository: LangRepositoryImpl(userDefaults: UserDefaults.standard,
                                                                             data: langData),
                                          notificationCenter: NotificationCenter.default,
                                          staticContent: newWordViewStaticContent,
                                          styles: newWordViewStyles)
        guard let newWordViewController = newWordMVVM.viewController else { return }

        newWordViewController.modalPresentationStyle = .overFullScreen

        present(newWordViewController, animated: true, completion: nil)
    }

    func set(wordList: [WordItem]) {
        tableController.wordList = wordList
    }

    func addNewRowToList() {
        let count = tableController.wordList.count - 1

        tableView.insertRows(at: [IndexPath(row: count, section: 0)], with: .automatic)
    }

    func updateRowAt(_ position: Int) {
        guard position > -1 && position < tableController.wordList.count else { return }

        tableView.reloadRows(at: [IndexPath(row: position, section: 0)], with: .automatic)
    }

    func removeRowAt(_ position: Int) {
        guard position > -1 && position <= tableController.wordList.count else { return }

        tableView.deleteRows(at: [IndexPath(row: position, section: 0)], with: .automatic)
    }

    func reloadList() {
        tableView.reloadData()
    }

    func onDeleteWordTap(_ position: Int) {
        let item = tableController.wordList[position]

        viewModel?.remove(item, position)
    }
}
