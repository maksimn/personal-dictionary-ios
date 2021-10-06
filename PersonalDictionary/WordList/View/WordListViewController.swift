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
        tableView.reloadData()
    }
}
