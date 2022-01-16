//
//  MainWordListViewParams.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import UIKit

/// Параметры представления Главного списка слов.
struct MainWordListViewParams {

    /// Заголовочный текст экрана
    let heading: String

    /// Картинка для кнопки навигации на экран добавления нового слова
    let navToNewWordImage: UIImage

    /// Надпись на кнопке навигации к другому приложению в супераппе
    let routingButtonTitle: String

    /// Максимальное количество видимых элементов (слов) на данном экране
    let visibleItemMaxCount: Int

    /// Цвет фона
    let backgroundColor: UIColor

    /// Размер кнопки навигации на экран добавления нового слова
    let navToNewWordButtonSize: CGSize

    /// Величина смещения нижней границы кнопки навигации на экран добавления нового слова
    let navToNewWordButtonBottomOffset: CGFloat
}
