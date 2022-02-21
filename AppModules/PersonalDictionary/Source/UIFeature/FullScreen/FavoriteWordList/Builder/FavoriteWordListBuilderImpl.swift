//
//  FavoriteWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

/// Билдер Фичи.
final class FavoriteWordListBuilderImpl: FavoriteWordListBuilder {

    init() {}

    /// Создать экран.
    /// - Returns:
    ///  - View controller экрана.
    func build() -> UIViewController {
        FavoriteWordListViewController()
    }
}

