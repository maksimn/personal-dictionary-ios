//
//  MainNavigatorBuilderImpl.swift
//  SuperList
//
//  Created by Maksim Ivanov on 26.02.2022.
//

/// Реализация билдера фичи "Контейнер элементов навигации на Главном экране приложения".
final class MainNavigatorBuilderImpl: MainNavigatorBuilder {

    private weak var dependency: AppDependency?

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    /// Создать контейнер.
    /// - Returns: объект контейнера.
    func build() -> MainNavigator {
        guard let dependency = dependency else { return Empty() }

        return MainNavigatorImpl(
            navigationController: dependency.navigationController,
            navToSearchBuilder: NavToSearchBuilderImpl(width: .full, dependency: dependency),
            navToFavoriteWordListBuilder: NavToFavoritesBuilder(dependency: dependency),
            navToNewWordBuilder: NavToNewWordBuilder(dependency: dependency),
            navToTodoListBuilder: NavToTodoListBuilder(
                rootViewController: dependency.navigationController,
                bundle: dependency.bundle
            )
        )
    }
}

private struct Empty: MainNavigator {

    func appendTo(rootView: UIView) { }
}
