//
//  WordTableController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

final class WordTableDataSource: NSObject, UITableViewDataSource {

    var data: WordListData {
        willSet {
            previousWordCount = data.wordList.count
        }
        didSet {
            updateTableView()
        }
    }

    private var previousWordCount = -1

    private unowned let tableView: UITableView

    init(tableView: UITableView,
         data: WordListData) {
        self.tableView = tableView
        self.data = data
        super.init()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.wordList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(WordItemCell.self)",
                                                       for: indexPath) as? WordItemCell else {
            return UITableViewCell()
        }
        let wordItem = data.wordList[indexPath.row]

        cell.set(wordItem: wordItem)

        return cell
    }

    // MARK: - Private

    private func updateTableView() {
        let wordList = data.wordList

        if wordList.count == previousWordCount - 1 {
            guard let changedItemPosition = verifyChangedItemPosition() else {
                tableView.reloadData()
                return
            }

            tableView.deleteRows(at: [IndexPath(row: changedItemPosition, section: 0)], with: .automatic)
        } else if wordList.count == previousWordCount {
            guard let changedItemPosition = verifyChangedItemPosition() else {
                tableView.reloadData()
                return
            }

            tableView.reloadRows(at: [IndexPath(row: changedItemPosition, section: 0)], with: .automatic)
        } else if wordList.count == previousWordCount + 1 {
            guard let changedItemPosition = verifyChangedItemPosition() else {
                tableView.reloadData()
                return
            }

            tableView.insertRows(at: [IndexPath(row: changedItemPosition, section: 0)], with: .automatic)
        } else {
            tableView.reloadData()
        }
    }

    private func verifyChangedItemPosition() -> Int? {
        guard let changedItemPosition = data.changedItemPosition,
              changedItemPosition > -1 && changedItemPosition <= data.wordList.count else {
            return nil
        }
        return changedItemPosition
    }
}
