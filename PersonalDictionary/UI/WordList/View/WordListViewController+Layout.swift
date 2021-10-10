//
//  ViewController+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

extension WordListViewController {

    func initViews() {
        view.backgroundColor = styles.backgroundColor
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(newWordButton)
        initSearchBar()
        initTableView()
        initNewWordButton()
    }

    func initSearchBar() {
        searchBar.isUserInteractionEnabled = false
        searchBar.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(44)
        }
    }

    private func initNewWordButton() {
        newWordButton.setImage(staticContent.newWordButtonImage, for: .normal)
        newWordButton.imageView?.contentMode = .scaleAspectFit
        newWordButton.addTarget(self, action: #selector(onNewWordButtonTap), for: .touchUpInside)
        newWordButton.snp.makeConstraints { make -> Void in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-26)
            make.centerX.equalTo(view)
        }
        if let imageView = newWordButton.imageView {
            imageView.snp.makeConstraints { (make) -> Void in
                make.edges.equalTo(newWordButton)
            }
        }
    }

    func initTableView() {
        tableView.backgroundColor = styles.backgroundColor
        tableView.layer.cornerRadius = 16
        tableView.rowHeight = WordItemCell.height
        tableView.register(WordItemCell.self, forCellReuseIdentifier: "\(WordItemCell.self)")
        tableView.dataSource = tableController
        tableView.delegate = tableController
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.snp.makeConstraints { make -> Void in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 54, left: 12, bottom: 0, right: 12))
        }

        tableController.swipeToDeleteActionFactory = SwipeToDeleteActionFactory(
            staticContent: staticContent.deleteAction,
            styles: styles.deleteAction,
            onDeleteTap: onDeleteWordTap
        )
    }
}
