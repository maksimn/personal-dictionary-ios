//
//  SearchModeViewImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

import CoreModule
import UIKit

/// Параметры представления выбора режима поиска.
struct SearchModePickerViewParams {

    /// Текст для лейбла "Искать по"
    let searchByLabelText: String

    /// Текст для выбора поиска по исходному слову.
    let sourceWordText: String

    /// Текст для выбора поиска по переводу..
    let translationText: String
}

/// Реализация представления для выбора режима поиска.
final class SearchModePickerView: UIView {

    private let params: SearchModePickerViewParams
    private let viewModel: SearchModePickerViewModel
    private let theme: Theme
    private let logger: SLogger

    private let label = UILabel()
    private lazy var segmentedControl = UISegmentedControl(items: [params.sourceWordText, params.translationText])

    /// Инициализатор.
    /// - Parameters:
    ///  - params: параметры представления.
    init(params: SearchModePickerViewParams,
         viewModel: SearchModePickerViewModel,
         theme: Theme,
         logger: SLogger) {
        self.params = params
        self.viewModel = viewModel
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
        logger.log("User has selected [\(sender.selectedSegmentIndex)] index of the search mode segmented control.")

        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.searchMode.accept(.bySourceWord)
        case 1:
            viewModel.searchMode.accept(.byTranslation)
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
        label.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.snp.top).offset(18)
            make.left.equalTo(self.snp.left).offset(26)
        }
    }

    private func initSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.snp.top).offset(10.5)
            make.right.equalTo(self.snp.right).offset(-22)
        }
    }
}
