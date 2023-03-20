//
//  NavToSearchRouterImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import RxSwift

/// Реализация роутера для навигации на экран Поиска.
final class NavToSearchRouter: EmptyRouter {

    private weak var navigationController: UINavigationController?
    private weak var searchViewController: UIViewController?
    private let searchBuilder: ViewControllerBuilder
    private let disposeBag = DisposeBag()

    /// - Parameters:
    ///  - navigationController: корневой navigation controller приложения.
    ///  - searchBuilder: билдер вложенной фичи "Поиск" по словам в словаре.
    init(navigationController: UINavigationController?,
         searchBuilder: ViewControllerBuilder,
         mainScreenStateStream: MainScreenStateStream) {
        self.navigationController = navigationController
        self.searchBuilder = searchBuilder
        subscribe(to: mainScreenStateStream.mainScreenState)
    }

    private func subscribe(to mainScreenState: Observable<MainScreenState>) {
        mainScreenState.subscribe(onNext: { [weak self] state in
            self?.onNext(state: state)
        }).disposed(by: disposeBag)
    }

    private func onNext(state: MainScreenState) {
        switch state {
        case .main:
            break

        case .search:
            guard searchViewController == nil else { return }
            let searchViewController = searchBuilder.build()

            navigationController?.viewControllers.first?.layout(childViewController: searchViewController)

            self.searchViewController = searchViewController
        case .empty:
            self.searchViewController?.removeFromParentViewController()
            self.searchViewController = nil
        }
    }
}
