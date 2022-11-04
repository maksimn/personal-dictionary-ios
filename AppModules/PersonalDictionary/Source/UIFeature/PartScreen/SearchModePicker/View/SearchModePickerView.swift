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
    private let viewModel: SearchModePickerViewModel

    private let searchByLabel = UILabel()
    private var searchBySegmentedControl: UISegmentedControl?
    private let disposeBag = DisposeBag()

    /// Инициализатор.
    /// - Parameters:
    ///  - params: параметры представления.
    ///  - viewModel: Модель представления выбора режима поиска.
    init(params: SearchModePickerViewParams,
         viewModel: SearchModePickerViewModel) {
        self.params = params
        self.viewModel = viewModel
        super.init(frame: .zero)
        initViews()
        bindToViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindToViewModel() {
        viewModel.searchMode.subscribe(onNext: { [weak self] searchMode in
            switch searchMode {
            case .bySourceWord:
                self?.searchBySegmentedControl?.selectedSegmentIndex = 0
            case .byTranslation:
                self?.searchBySegmentedControl?.selectedSegmentIndex = 1
            }
        }).disposed(by: disposeBag)
    }

    @objc
    private func onSearchByValueChanged() {
        guard let selectedIndex = searchBySegmentedControl?.selectedSegmentIndex else { return }

        switch selectedIndex {
        case 0:
            viewModel.searchMode.accept(.bySourceWord)
        case 1:
            viewModel.searchMode.accept(.byTranslation)
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
        searchBySegmentedControl = UISegmentedControl(items: [params.sourceWordText, params.translationText])
        searchBySegmentedControl?.selectedSegmentIndex = 0
        searchBySegmentedControl?.addTarget(self, action: #selector(onSearchByValueChanged), for: .valueChanged)
        addSubview(searchBySegmentedControl ?? UIView())
        searchBySegmentedControl?.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.snp.top).offset(10.5)
            make.right.equalTo(self.snp.right).offset(-22)
        }
    }
}
