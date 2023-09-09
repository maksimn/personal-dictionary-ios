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

    let activityIndicator = UIActivityIndicatorView()
    let tableView = UITableView()
    let label: UILabel
    let retryButton = UIButton()
    let translationDirectionView = TranslationDirectionView()
    let disposeBag = DisposeBag()

    lazy var datasource = UITableViewDiffableDataSource<Int, String>(
        tableView: tableView) { tableView, indexPath, str in
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)

        cell.textLabel?.text = str

        return cell
    }

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
        tableViewFor(state)
        labelFor(state)
        retryButtonFor(state)
        titleAndTranslationDirectionViewFor(state)
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

    private func tableViewFor(_ state: DictionaryEntryState) {
        switch state {
        case .loaded(let wordData):
            var snapshot = NSDiffableDataSourceSnapshot<Int, String>()

            snapshot.appendSections([0])
            snapshot.appendItems(wordData.entry, toSection: 0)
            datasource.apply(snapshot)

        default:
            break
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

    private func titleAndTranslationDirectionViewFor(_ state: DictionaryEntryState) {
        switch state {
        case .loaded(let wordData):
            setTitleAndTranslationDirection(wordData.word)

        case .error(let withError):
            if case DictionaryEntryError.emptyDictionaryEntry(let word) = withError.base {
                translationDirectionView.isHidden = false
                setTitleAndTranslationDirection(word)
            } else {
                translationDirectionView.isHidden = true
            }

        default:
            break
        }
    }

    private func setTitleAndTranslationDirection(_ word: Word) {
        navigationItem.title = word.text
        translationDirectionView.set(sourceLang: word.sourceLang, targetLang: word.targetLang)
    }
}
