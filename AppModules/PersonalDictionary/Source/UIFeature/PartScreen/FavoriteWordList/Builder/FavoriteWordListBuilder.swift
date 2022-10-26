//
//  WordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

/// Билдер фичи "Список избранных слов".
protocol FavoriteWordListBuilder {

    func build() -> UIViewController
}
