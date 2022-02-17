//
//  ViewController+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

/// Лэйаут представления списка слов.
extension WordListViewController {

    func initViews() {
        view.backgroundColor = Theme.standard.backgroundColor
        view.addSubview(tableView)
        tableView.backgroundColor = Theme.standard.backgroundColor
        tableView.layer.cornerRadius = params.cellCornerRadius
        tableView.rowHeight = params.itemHeight
        tableView.register(params.cellClass, forCellReuseIdentifier: params.cellReuseIdentifier)
        tableView.dataSource = datasource
        tableView.delegate = tableActions
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.snp.makeConstraints { make -> Void in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 14, left: 12, bottom: 0, right: 12))
        }
        tableView.keyboardDismissMode = .onDrag
    }
}
