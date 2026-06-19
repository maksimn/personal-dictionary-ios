//
//  SearchModeViewImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

import CoreModule
import UIKit

/// Parameters of the search mode selection view.
struct SearchModePickerViewParams {

    /// Text for the "Search by" label
    let searchByLabelText: String

    /// Text for selecting search by source word.
    let sourceWordText: String

    /// Text for selecting search by translation.
    let translationText: String
}

/// Implementation of the search mode selection view.
final class SearchModePickerView: UIView {

    private let params: SearchModePickerViewParams
    private let searchModeSender: SearchModeSender
    private let theme: Theme
    private let logger: Logger

    private let label = UILabel()
    private lazy var segmentedControl = UISegmentedControl(items: [params.sourceWordText, params.translationText])

    /// Initializer.
    /// - Parameters:
    ///  - params: view parameters.
    init(
        searchModeSender: SearchModeSender,
        params: SearchModePickerViewParams,
        theme: Theme,
        logger: Logger
    ) {
        self.searchModeSender = searchModeSender
        self.params = params
        self.theme = theme
        self.logger = logger
        super.init(frame: .zero)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        logger.debug("User has selected [\(sender.selectedSegmentIndex)] index of the search mode segmented control.")

        switch sender.selectedSegmentIndex {
        case 0:
            searchModeSender.send(.bySourceWord)
        case 1:
            searchModeSender.send(.byTranslation)
        default:
            break
        }
    }

    private func initViews() {
        initLabel()
        initSegmentedControl()
    }

    private func initLabel() {
        label.textColor = theme.secondaryTextColor
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = params.searchByLabelText
        addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(18)
            make.left.equalTo(self.snp.left).offset(26)
        }
    }

    private func initSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10.5)
            make.right.equalTo(self.snp.right).offset(-22)
        }
    }
}
