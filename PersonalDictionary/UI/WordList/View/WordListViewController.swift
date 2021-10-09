//
//  ViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

class WordListViewController: UIViewController, WordListView {

    var viewModel: WordListViewModel?

    let tableView = UITableView()
    let tableController = WordTableController()

    let newWordButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        viewModel?.fetchDataFromModel()
    }

    @objc
    func onNewWordButtonTap() {
        let newWordMVVM = NewWordMVVMImpl(langRepository: LangRepositoryImpl(userDefaults: UserDefaults.standard,
                                                                             data: langResourceData),
                                          notificationCenter: NotificationCenter.default,
                                          viewResource: newWordViewResource)
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
