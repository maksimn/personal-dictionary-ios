//
//  WordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

/// Builder of the "Word List" feature.
protocol WordListBuilder {

    /// Create the feature graph
    /// - Returns:
    ///  - feature graph.
    func build() -> WordListGraph
}
