//
//  ViewController+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

extension WordListViewController {

    func initViews() {
        view.backgroundColor = params.styles.backgroundColor
        view.addSubview(tableView)
        tableView.backgroundColor = params.styles.backgroundColor
        tableView.layer.cornerRadius = 16
        tableView.rowHeight = WordItemCell.height
        tableView.register(WordItemCell.self, forCellReuseIdentifier: "\(WordItemCell.self)")
        tableView.dataSource = tableDataSource
        tableView.delegate = tableActions
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.snp.makeConstraints { make -> Void in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 14, left: 12, bottom: 0, right: 12))
        }
    }
}
