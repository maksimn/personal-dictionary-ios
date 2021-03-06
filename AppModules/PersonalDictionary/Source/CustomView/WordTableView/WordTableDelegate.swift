//
//  WordTableDelegate.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.11.2021.
//

import UIKit

/// Параметры делегата таблицы слов из личного словаря.
struct WordTableDelegateParams {

    /// Запускать ли анимацию при первом появлении данных в таблице.
    let shouldAnimateWhenAppear: Bool

    /// Длительность анимации слайда ячейки при её первом показе
    let cellSlideInDuration: Double

    /// Фактор задержки анимации последующих ячеек
    let cellSlideInDelayFactor: Double

    /// Картинка для действия удаления элемента из таблицы
    let deleteActionImage: UIImage

    /// Цвет фона для действия удаления элемента из таблицы
    let deleteActionBackgroundColor: UIColor

    /// Картинка для действия добавления/удаления элемента из Избранного
    let favoriteActionImage: UIImage

    /// Цвет фона для действия добавления/удаления элемента из Избранного
    let favoriteActionBackgroundColor: UIColor
}

/// Делегат событий для таблицы слов из словаря.
final class WordTableDelegate: NSObject, UITableViewDelegate {

    private let params: WordTableDelegateParams
    private var onDeleteTap: ((Int) -> Void)?
    private var onScrollFinish: (() -> Void)?
    private var onFavoriteTap: ((Int) -> Void)?

    private var hasAnimatedAllCells = false

    /// Инициализатор
    /// - Parameters:
    ///  - params: параметры делегата таблицы слов из личного словаря.
    ///  - onScrollFinish: обработчик для события завершения скролла таблицы.
    ///  - onDeleteTap: обработчик нажатия на view для удаления элемента таблицы.
    ///  - onFavoriteTap: обработчик нажатия на view для добавления/удаления элемента из Избранного.
    init(params: WordTableDelegateParams,
         onScrollFinish: (() -> Void)?,
         onDeleteTap: ((Int) -> Void)?,
         onFavoriteTap: ((Int) -> Void)?) {
        self.onScrollFinish = onScrollFinish
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

    // MARK: - UIScrollViewDelegate

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        onScrollFinish?()
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
