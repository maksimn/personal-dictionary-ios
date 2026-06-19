//
//  SearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import CoreModule
import UIKit

/// Builder for the "Search Words in Dictionary" feature.
final class SearchBuilder: ViewControllerBuilder {

    private let dependency: AppDependency

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    /// Create the Search screen.
    /// - Returns:
    ///  - View controller of the search screen for words in the dictionary.
    func build() -> UIViewController {
        SearchViewController(
            searchModePickerBuilder: SearchModePickerBuilder(bundle: dependency.bundle),
            searchWordListBuilder: SearchWordListBuilder(dependency: dependency),
            theme: Theme.data
        )
    }
}
