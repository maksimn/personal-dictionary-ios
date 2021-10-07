//
//  WordTableController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

final class WordTableController: NSObject, UITableViewDataSource, UITableViewDelegate {

    var wordList: [WordItem] = []

    var onDeleteTap: ((Int) -> Void)?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        wordList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(WordItemCell.self)",
                                                       for: indexPath) as? WordItemCell else {
            return UITableViewCell()
        }
        let wordItem = wordList[indexPath.row]

        cell.set(wordItem: wordItem)

        return cell
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "",
                                              handler: { (_, _, success: (Bool) -> Void) in
                                                self.onDeleteTap?(indexPath.row)
                                                success(true)
                                              })

        deleteAction.image = UIImage(systemName: "trash",
                                     withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!
        deleteAction.backgroundColor = UIColor(red: 1, green: 0.271, blue: 0.227, alpha: 1)

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
