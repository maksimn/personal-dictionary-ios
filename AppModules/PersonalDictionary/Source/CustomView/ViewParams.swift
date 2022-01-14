//
//  ViewParams.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 03.11.2021.
//

/**
 * ЗАМЕЧАНИЕ: Использование объектов подобных структур создаёт сложности при описании параметров
 * вложенных представлений и поэтому в дальнейшем неоправданно.
 * Вместо них стоит использовать "плоские" структуры, то есть объекты без разделения на staticContent и styles.
 */
/// Обобщённый объект структуры, описывающей параметры для представлений.
struct ViewParams<StaticContent, Styles> {

    /// Статический контент: строки, UIImage, массивы объектов со статическим контентом и т. п.
    let staticContent: StaticContent

    /// "Стили": цвета, размеры view и т. п.
    let styles: Styles
}
