//
//  WordTableDelegate.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.11.2021.
//

import UIKit

/// Parameters for the word list table delegate from the personal dictionary.
struct WordTableViewDelegateParams {

    /// Whether to run animation when data first appears in the table.
    let shouldAnimateWhenAppear: Bool

    /// Duration of the cell slide-in animation on its first appearance
    let cellSlideInDuration: Double

    /// Delay factor for subsequent cell animations
    let cellSlideInDelayFactor: Double

    /// Image for the delete action on the table item
    let deleteActionImage: UIImage

    /// Background color for the delete action on the table item
    let deleteActionBackgroundColor: UIColor

    /// Image for the add/remove from Favorites action
    let favoriteActionImage: UIImage

    /// Background color for the add/remove from Favorites action
    let favoriteActionBackgroundColor: UIColor
}

/// Event delegate for the dictionary word table.
final class WordTableViewDelegate: NSObject, UITableViewDelegate {

    private let params: WordTableViewDelegateParams
    private var onDeleteTap: ((Int) -> Void)?
    private var onFavoriteTap: ((Int) -> Void)?

    private var hasAnimatedAllCells = false

    /// - Parameters:
    ///  - params: parameters of the word list table delegate from the personal dictionary.
    ///  - onDeleteTap: handler for tapping the view to delete a table item.
    ///  - onFavoriteTap: handler for tapping the view to add/remove an item from Favorites.
    init(params: WordTableViewDelegateParams,
         onDeleteTap: ((Int) -> Void)?,
         onFavoriteTap: ((Int) -> Void)?) {
        self.onDeleteTap = onDeleteTap
        self.onFavoriteTap = onFavoriteTap
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

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favoriteAction = UIContextualAction(
            style: .normal, title: "",
            handler: { [weak self] (_, _, success: (Bool) -> Void) in
                self?.onFavoriteTap?(indexPath.row)
                success(true)
            }
        )

        favoriteAction.image = params.favoriteActionImage
        favoriteAction.backgroundColor = params.favoriteActionBackgroundColor

        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        runCellSlideInAnimationIfNeeded(tableView, cell: cell, indexPath: indexPath)
    }

    // MARK: - Private

    private func runCellSlideInAnimationIfNeeded(_ tableView: UITableView,
                                                 cell: UITableViewCell,
                                                 indexPath: IndexPath) {
        guard params.shouldAnimateWhenAppear,
              !hasAnimatedAllCells else { return }

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
