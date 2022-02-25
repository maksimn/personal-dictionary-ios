//
//  MainWordListViewParams.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import UIKit

/// Параметры представления Главного списка слов.
struct MainWordListViewParams {

    /// Текст заголовка
    let heading: String

    /// Надпись на кнопке навигации к другому приложению в супераппе
    let routingButtonTitle: String

    /// Максимальное количество видимых элементов (слов) на данном экране
    let visibleItemMaxCount: Int
}
