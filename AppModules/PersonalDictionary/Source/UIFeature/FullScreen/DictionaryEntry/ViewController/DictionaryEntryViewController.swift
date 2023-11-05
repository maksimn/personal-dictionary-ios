//
//  DictionaryEntryViewController.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import RxSwift
import UIKit

struct DictionaryEntryViewParams {
    let errorText: String
    let retryButtonText: String
}

final class DictionaryEntryViewController: UIViewController {

    let viewModel: DictionaryEntryViewModel
    let params: DictionaryEntryViewParams
    let theme: Theme

    lazy var dictionaryEntryView = DictionaryEntryView(theme: theme)

    let activityIndicator = UIActivityIndicatorView()
    let label: UILabel
    let retryButton = UIButton()
    let disposeBag = DisposeBag()

    init(viewModel: DictionaryEntryViewModel, params: DictionaryEntryViewParams, theme: Theme) {
        self.viewModel = viewModel
        self.params = params
        self.theme = theme
        label = secondaryText(params.errorText, theme)
        super.init(nibName: nil, bundle: nil)
        initViews()
        bindToViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.load()
    }

    private func bindToViewModel() {
        viewModel.state.subscribe(onNext: { [weak self] in
            self?.set(state: $0)
        }).disposed(by: disposeBag)
    }

    private func set(state: DictionaryEntryState) {
        activityIndicatorFor(state)
        labelFor(state)
        retryButtonFor(state)
        titleAndDictionaryEntryViewFor(state)
    }

    @objc
    func onRetryButtonTap() {
        viewModel.retryDictionaryEntryRequest()
    }

    private func activityIndicatorFor(_ state: DictionaryEntryState) {
        switch state {
        case .loading:
            activityIndicator.startAnimating()

        default:
            activityIndicator.stopAnimating()
        }
    }

    private func labelFor(_ state: DictionaryEntryState) {
        switch state {
        case .error:
            label.isHidden = false

        default:
            label.isHidden = true
        }
    }

    private func retryButtonFor(_ state: DictionaryEntryState) {
        switch state {
        case .error:
            retryButton.isHidden = false

        default:
            retryButton.isHidden = true
        }
    }

    private func titleAndDictionaryEntryViewFor(_ state: DictionaryEntryState) {
        switch state {
        case .loaded(let wordData):
            navigationItem.title = wordData.word.text
            dictionaryEntryView.set(data: (wordData.word, wordData.entry))

        case .error(let withError):
            if case DictionaryEntryError.emptyDictionaryEntry(let word) = withError.base {
                navigationItem.title = word.text
                dictionaryEntryView.set(data: (word, []))
            }

        default:
            break
        }
    }
}
