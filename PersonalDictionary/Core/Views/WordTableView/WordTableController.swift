//
//  WordTableController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

final class WordTableController: NSObject, UITableViewDataSource, UITableViewDelegate {

    var wordList: [WordItem] = []

    var swipeToDeleteActionFactory: SwipeToDeleteActionFactory?

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
        guard let deleteAction = swipeToDeleteActionFactory?.create(for: indexPath.row) else { return nil }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
