//
//  SearchModeViewImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

import UIKit

final class SearchModePickerViewImpl: UIView, SearchModePickerView {

    var viewModel: SearchModePickerViewModel?

    let searchByLabel = UILabel()
    var searchBySegmentedControl: UISegmentedControl?

    let params: SearchModePickerViewParams

    init(params: SearchModePickerViewParams) {
        self.params = params
        super.init(frame: .zero)
        initSearchByLabel()
        initSearchBySegmentedControl()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(_ searchMode: SearchMode) {
        switch searchMode {
        case .bySourceWord:
            searchBySegmentedControl?.selectedSegmentIndex = 0
        case .byTranslation:
            searchBySegmentedControl?.selectedSegmentIndex = 1
        }
    }

    @objc
    func onSearchByValueChanged() {
        guard let selectedIndex = searchBySegmentedControl?.selectedSegmentIndex else { return }

        switch selectedIndex {
        case 0:
            viewModel?.update(.bySourceWord)
        case 1:
            viewModel?.update(.byTranslation)
        default:
            break
        }
    }

    private func initSearchByLabel() {
        searchByLabel.textColor = .darkGray
        searchByLabel.font = UIFont.systemFont(ofSize: 16)
        searchByLabel.numberOfLines = 1
        searchByLabel.textAlignment = .center
        searchByLabel.text = params.staticContent.searchByLabelText
        addSubview(searchByLabel)
        searchByLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.snp.top).offset(18)
            make.left.equalTo(self.snp.left).offset(26)
        }
    }

    private func initSearchBySegmentedControl() {
        searchBySegmentedControl = UISegmentedControl(items: [params.staticContent.sourceWordText,
                                                              params.staticContent.translationText])
        searchBySegmentedControl?.selectedSegmentIndex = 0
        searchBySegmentedControl?.addTarget(self, action: #selector(onSearchByValueChanged), for: .valueChanged)
        addSubview(searchBySegmentedControl ?? UIView())
        searchBySegmentedControl?.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.snp.top).offset(10.5)
            make.right.equalTo(self.snp.right).offset(-22)
        }
    }
}
