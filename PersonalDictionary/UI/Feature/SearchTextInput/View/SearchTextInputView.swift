//
//  SearchTextInputView.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

protocol SearchTextInputView: AnyObject {

    var viewModel: SearchTextInputViewModel? { get set }

    var uiview: UIView { get }
}
