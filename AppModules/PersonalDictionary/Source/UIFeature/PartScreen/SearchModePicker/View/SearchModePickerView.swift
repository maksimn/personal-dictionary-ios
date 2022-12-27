//
//  SearchModeViewImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

import RxSwift
import UIKit

/// Реализация представления для выбора режима поиска.
final class SearchModePickerView: UIView {

    private let params: SearchModePickerViewParams
    private let model: SearchModePickerModel

    private let searchByLabel = UILabel()
    private lazy var searchBySegmentedControl = UISegmentedControl(
        items: [params.sourceWordText, params.translationText]
    )

    private let disposeBag = DisposeBag()

    /// Инициализатор.
    /// - Parameters:
    ///  - params: параметры представления.
    init(params: SearchModePickerViewParams,
         model: SearchModePickerModel) {
        self.params = params
        self.model = model
        super.init(frame: .zero)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func onSearchByValueChanged(_ value: Int) {
        switch value {
        case 0:
            model.set(searchMode: .bySourceWord)
        case 1:
            model.set(searchMode: .byTranslation)
        default:
            break
        }
    }

    private func initViews() {
        initSearchByLabel()
        initSearchBySegmentedControl()
    }

    private func initSearchByLabel() {
        searchByLabel.textColor = Theme.data.secondaryTextColor
        searchByLabel.font = UIFont.systemFont(ofSize: 16)
        searchByLabel.numberOfLines = 1
        searchByLabel.textAlignment = .center
        searchByLabel.text = params.searchByLabelText
        addSubview(searchByLabel)
        searchByLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.snp.top).offset(18)
            make.left.equalTo(self.snp.left).offset(26)
        }
    }

    private func initSearchBySegmentedControl() {
        searchBySegmentedControl.selectedSegmentIndex = 0
        searchBySegmentedControl.rx.value.subscribe(onNext: { [weak self] value in
            self?.onSearchByValueChanged(value)
        }).disposed(by: disposeBag)
        addSubview(searchBySegmentedControl)
        searchBySegmentedControl.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.snp.top).offset(10.5)
            make.right.equalTo(self.snp.right).offset(-22)
        }
    }
}
