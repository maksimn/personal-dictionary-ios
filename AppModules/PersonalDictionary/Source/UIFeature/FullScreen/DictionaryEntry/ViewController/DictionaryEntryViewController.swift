//
//  DictionaryEntryViewController.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import RxSwift
import UIKit

final class DictionaryEntryViewController: UIViewController {

    private let viewModel: DictionaryEntryViewModel
    private let errorText: String
    private let theme: Theme

    private let tableView = UITableView()
    private let label: UILabel
    private let translationDirectionView = TranslationDirectionView()
    private let disposeBag = DisposeBag()

    private lazy var datasource = UITableViewDiffableDataSource<Int, String>(
        tableView: tableView) { tableView, indexPath, str in
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)

        cell.textLabel?.text = str

        return cell
    }

    init(viewModel: DictionaryEntryViewModel, errorText: String, theme: Theme) {
        self.viewModel = viewModel
        self.errorText = errorText
        self.theme = theme
        label = secondaryText(errorText, theme)
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

    private func initViews() {
        view.backgroundColor = theme.backgroundColor
        initTranslationDirectionView()
        initTableView()
        initLabel()
    }

    private func bindToViewModel() {
        viewModel.state.subscribe(onNext: { [weak self] in
            self?.set(state: $0)
        }).disposed(by: disposeBag)
    }

    private func set(state: DictionaryEntryState) {
        switch state {
        case .initial:
            label.isHidden = true

        case .with(let word):
            navigationItem.title = word.text
            translationDirectionView.set(sourceLang: word.sourceLang, targetLang: word.targetLang)

            if word.dictionaryEntry.isEmpty {
                label.isHidden = false
                return
            }

            label.isHidden = true

            var snapshot = NSDiffableDataSourceSnapshot<Int, String>()

            snapshot.appendSections([0])
            snapshot.appendItems(word.dictionaryEntry, toSection: 0)

            datasource.apply(snapshot)

        case .error:
            label.isHidden = false
        }
    }

    private func initTranslationDirectionView() {
        let parentView = UIView()

        view.addSubview(parentView)
        parentView.addSubview(translationDirectionView)
        parentView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.left.equalTo(view.safeAreaLayoutGuide)
            make.right.equalTo(view.safeAreaLayoutGuide)
        }
        translationDirectionView.layoutTo(view: parentView)
    }

    private func initTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = theme.backgroundColor
        tableView.layer.cornerRadius = 8
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
        tableView.dataSource = datasource
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
                .inset(UIEdgeInsets(top: 38, left: 12, bottom: 12, right: 12))
        }
    }

    private func initLabel() {
        view.addSubview(label)
        label.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(view).offset(-20)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
    }
}
