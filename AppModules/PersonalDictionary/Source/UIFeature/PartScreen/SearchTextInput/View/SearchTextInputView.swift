//
//  SearchTextInputView.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

/// Представление элемента ввода поискового текста.
protocol SearchTextInputView: AnyObject {

    /// UIView элемента ввода поискового текста.
    var uiview: UIView { get }
}
