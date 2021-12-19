//
//  ViewController+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

extension WordListViewController {

    func initViews() {
        let styles = params.styles

        view.backgroundColor = styles.backgroundColor
        view.addSubview(tableView)
        tableView.backgroundColor = styles.backgroundColor
        tableView.layer.cornerRadius = styles.cellCornerRadius
        tableView.rowHeight = styles.itemHeight
        tableView.register(styles.cellClass, forCellReuseIdentifier: styles.cellReuseIdentifier)
        tableView.dataSource = tableDataSource
        tableView.delegate = tableActions
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.snp.makeConstraints { make -> Void in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 14, left: 12, bottom: 0, right: 12))
        }
        tableView.keyboardDismissMode = .onDrag
    }
}
