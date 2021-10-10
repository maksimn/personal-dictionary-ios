//
//  StaticContent.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.10.2021.
//

import UIKit

let wordListViewStaticContent = WordListViewStaticContent(
    newWordButtonImage: UIImage(named: "icon-plus")!,
    deleteAction: DeleteActionStaticContent(
        image: UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!
    )
)

let newWordViewStaticContent = NewWordViewStaticContent(selectButtonTitle: NSLocalizedString("Select", comment: ""),
                                              arrowText: NSLocalizedString("⇋", comment: ""),
                                              okText: NSLocalizedString("OK", comment: ""),
                                              textFieldPlaceholder: NSLocalizedString("Enter a new word", comment: ""))
