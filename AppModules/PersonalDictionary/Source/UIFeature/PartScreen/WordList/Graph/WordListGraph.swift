//
//  WordListGraph.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

/// Graph of the "Word List" feature.
protocol WordListGraph {

    var view: UIView { get }

    /// Word list model
    var viewModel: WordListViewModel { get }
}
