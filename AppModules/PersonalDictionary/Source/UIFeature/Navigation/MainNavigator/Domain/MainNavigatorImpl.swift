//
//  MainNavigatorImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 26.02.2022.
//

import CoreModule
import RxCocoa
import RxSwift
import UIKit

/// Реализация контейнера элементов навигации на Главном экране приложения.
final class MainNavigatorImpl: MainNavigator {

    private lazy var navigationItem = navigationItemGetter()

    private let navigationItemGetter: () -> UINavigationItem?
    private let searchTextInputView: UISearchController
    private let navToSearchRouter: NavToSearchRouter
    private let navToNewWordView: UIView
    private let navToFavoritesView: UIView
    private let navToTodoListView: UIView
    private let disposeBag = DisposeBag()

    /// Инициализатор,
    /// - Parameters:
    ///  - navToFavoritesBuilder: билдер вложенной фичи "Элемент навигации на экран списка избранных слов".
    ///  - navToTodoListBuilder: билдер вложенной фичи "Элемент навигации к приложению TodoList".
    init(
        navigationItemGetter: @escaping () -> UINavigationItem?,
        searchTextInputView: UISearchController,
        navToSearchBuilder: NavToSearchBuilder,
        navToNewWordBuilder: ViewBuilder,
        navToFavoritesBuilder: ViewBuilder,
        navToTodoListBuilder: ViewBuilder
    ) {
        self.navigationItemGetter = navigationItemGetter
        self.searchTextInputView = searchTextInputView
        self.navToSearchRouter = navToSearchBuilder.build()
        self.navToNewWordView = navToNewWordBuilder.build()
        self.navToFavoritesView = navToFavoritesBuilder.build()
        self.navToTodoListView = navToTodoListBuilder.build()
        subscribeToSearchTextInput()
    }

    func appendTo(rootView: UIView) {
        addNavToNewWord(rootView)
        navigationItem?.leftBarButtonItem = UIBarButtonItem(customView: navToFavoritesView)
        navigationItem?.rightBarButtonItem = UIBarButtonItem(customView: navToTodoListView)
    }

    func viewWillLayoutSubviews() {
        guard navigationItem?.searchController == nil else { return }

        navigationItem?.searchController = searchTextInputView
    }

    private func addNavToNewWord(_ view: UIView) {
        view.addSubview(navToNewWordView)
        navToNewWordView.snp.makeConstraints { make -> Void in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-26)
            make.centerX.equalTo(view)
        }
    }

    private func subscribeToSearchTextInput() {
        searchTextInputView.rx.willDismiss
            .subscribe(onNext: { [weak self] in
                self?.searchTextInputWillDismiss()
            }).disposed(by: disposeBag)

        searchTextInputView.rx.didDismiss
            .subscribe(onNext: { [weak self] in
                self?.searchTextInputDidDismiss()
            }).disposed(by: disposeBag)

        searchTextInputView.rx.willPresent
            .subscribe(onNext: { [weak self] in
                self?.searchTextInputWillPresent()
            }).disposed(by: disposeBag)

        searchTextInputView.rx.didPresent
            .subscribe(onNext: { [weak self] in
                self?.searchTextInputDidPresent()
            }).disposed(by: disposeBag)
    }

    private func searchTextInputWillDismiss() {
        navToSearchRouter.dismissSearch()
    }

    private func searchTextInputDidDismiss() {
        navToNewWordView.isHidden = false
    }

    private func searchTextInputWillPresent() {
        navToNewWordView.isHidden = true
    }

    private func searchTextInputDidPresent() {
        navToSearchRouter.presentSearch()
    }
}
