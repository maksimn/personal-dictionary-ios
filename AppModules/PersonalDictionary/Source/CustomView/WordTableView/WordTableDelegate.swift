//
//  WordTableDelegate.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.11.2021.
//

import UIKit

struct WordTableViewParams {
    let cellSlideInDuration: Double
    let cellSlideInDelayFactor: Double
    let deleteActionImage: UIImage
    let deleteActionBackgroundColor: UIColor
}

final class WordTableDelegate: NSObject, UITableViewDelegate {

    var changedItemPosition: Int = -1

    private let params: WordTableViewParams
    private var onDeleteTap: ((Int) -> Void)?
    private var onScrollFinish: (() -> Void)?

    private var hasAnimatedAllCells = false

    init(onScrollFinish: (() -> Void)?,
         onDeleteTap: ((Int) -> Void)?,
         params: WordTableViewParams) {
        self.onScrollFinish = onScrollFinish
        self.onDeleteTap = onDeleteTap
        self.params = params
        super.init()
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let onDeleteTap = onDeleteTap else { return nil }
        let deleteAction = UIContextualAction(style: .normal, title: "",
                                              handler: { (_, _, success: (Bool) -> Void) in
                                                onDeleteTap(indexPath.row)
                                                success(true)
                                              })

        deleteAction.image = params.deleteActionImage
        deleteAction.backgroundColor = params.deleteActionBackgroundColor

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        runCellSlideInAnimationIfNeeded(tableView, cell: cell, indexPath: indexPath)
    }

    // MARK: - UIScrollViewDelegate

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        onScrollFinish?()
    }

    // MARK: - Private

    private func runCellSlideInAnimationIfNeeded(_ tableView: UITableView,
                                                 cell: UITableViewCell,
                                                 indexPath: IndexPath) {
        guard !hasAnimatedAllCells else {
            return
        }

        cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)

        UIView.animate(
            withDuration: params.cellSlideInDuration,
            delay: params.cellSlideInDelayFactor * Double(indexPath.row),
            options: [.curveEaseInOut],
            animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        )

        hasAnimatedAllCells = tableView.isLastVisibleCell(at: indexPath)
    }
}
