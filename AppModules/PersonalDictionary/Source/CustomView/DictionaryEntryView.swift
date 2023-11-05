//
//  DictionaryEntryView.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 06.11.2023.
//

import UIKit

final class DictionaryEntryView: UIView, UITableViewDelegate {

    private let theme: Theme

    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let translationDirectionView = TranslationDirectionView()

    private var word: Word?
    private var entry: DictionaryEntry?

    private let sectionHeaderDefaultHeight: CGFloat = 17
    private let sectionHeaderWithTitleHeight: CGFloat = 44
    private let sectionHeaderWithWordclassHeight: CGFloat = 39
    private let sectionHeaderWithTitleAndWordclassHeight: CGFloat = 71

    private lazy var datasource = UITableViewDiffableDataSource<Int, SubitemVO>(
        tableView: tableView) { [weak self] tableView, indexPath, subitemVO in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(TableViewCell.self)",
                                                       for: indexPath) as? TableViewCell,
            let theme = self?.theme else { return UITableViewCell() }

        cell.set(data: subitemVO, theme)

        return cell
    }

    init(theme: Theme) {
        self.theme = theme
        super.init(frame: .zero)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(data: (word: Word, entry: DictionaryEntry)) {
        word = data.word
        entry = data.entry
        tableViewFor(data.entry)
        translationDirectionView.set(sourceLang: data.word.sourceLang, targetLang: data.word.targetLang)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: "\(SectionHeaderView.self)") as? SectionHeaderView,
            let word = word,
            let entry = entry,
            let item = entry[safeIndex: section] else { return nil }

        view.set(
            title: word.text.lowercased() == item.title.lowercased() ? "" : item.title,
            wordclass: item.subtitle.localizedString,
            theme: theme
        )

        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let word = word,
              let entry = entry,
              let item = entry[safeIndex: section] else { return sectionHeaderDefaultHeight }
        let title = word.text.lowercased() == item.title.lowercased() ? "" : item.title
        let wordclass = item.subtitle.localizedString

        if title.isEmpty && wordclass.isEmpty {
            return sectionHeaderDefaultHeight
        } else if title.isEmpty && !wordclass.isEmpty {
            return sectionHeaderWithWordclassHeight
        } else if !title.isEmpty && wordclass.isEmpty {
            return sectionHeaderWithTitleHeight
        } else {
            return sectionHeaderWithTitleAndWordclassHeight
        }
    }

    private func tableViewFor(_ entry: DictionaryEntry) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, SubitemVO>()

        for i in 0..<entry.count {
            snapshot.appendSections([i])
            snapshot.appendItems(
                entry[i].subitems.enumerated().map { SubitemVO($0.element, index: $0.offset + 1) },
                toSection: i
            )
        }

        datasource.apply(snapshot)
    }

    private func initViews() {
        initTableView()
        initTranslationDirectionView()
    }

    private func initTranslationDirectionView() {
        let parentView = UIView()

        self.addSubview(parentView)
        parentView.addSubview(translationDirectionView)
        parentView.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.left.equalTo(self.safeAreaLayoutGuide)
            make.right.equalTo(self.safeAreaLayoutGuide)
        }
        translationDirectionView.layoutTo(view: parentView)
    }

    private func initTableView() {
        self.addSubview(tableView)
        tableView.backgroundColor = theme.backgroundColor
        tableView.layer.cornerRadius = 8
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "\(SectionHeaderView.self)")
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "\(TableViewCell.self)")
        tableView.dataSource = datasource
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self.self.safeAreaLayoutGuide)
                .inset(UIEdgeInsets(top: 38, left: 17, bottom: 16, right: 17))
        }
        tableView.bounces = false
        tableView.delegate = self
    }
}

private struct SubitemVO: Equatable, Hashable {
    let id: String = UUID().uuidString
    let title: NSAttributedString
    let subtitle: String

    init(_ subitem: DictionaryEntrySubitem, index: Int) {
        let numberPrefix = "\(index). "
        let translationString = subitem.translation
        let contextString = subitem.context.isEmpty ? ""
            : "(\(subitem.context.map { $0.localizedString }.joined(separator: ", ")))"
        let contextAttrString = NSAttributedString(
            string: contextString,
            attributes: [.font: UIFont.italicSystemFont(ofSize: 17)]
        )
        let titleAttrString = NSMutableAttributedString(string: numberPrefix + translationString + " ")

        titleAttrString.append(contextAttrString)

        title = titleAttrString
        subtitle = subitem.example ?? ""
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

private final class TableViewCell: UITableViewCell {

    private let translationLabel = UILabel()
    private let exampleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(data: SubitemVO, _ theme: Theme) {
        translationLabel.attributedText = data.title
        exampleLabel.text = data.subtitle
        updateLayout(isExampleHidden: data.subtitle.isEmpty)
        translationLabel.textColor = theme.textColor
        exampleLabel.textColor = theme.secondaryTextColor
        contentView.backgroundColor = theme.wordCellColor
    }

    private func initViews() {
        selectionStyle = .none
        initTranslationLabel()
        initExampleLabel()
        setConstraints()
    }

    private func initTranslationLabel() {
        translationLabel.numberOfLines = 0
        contentView.addSubview(translationLabel)
    }

    private func initExampleLabel() {
        exampleLabel.numberOfLines = 0
        contentView.addSubview(exampleLabel)
    }

    private func setConstraints() {
        translationLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.contentView.snp.top).offset(12)
            make.left.equalTo(self.contentView.snp.left).offset(16)
            make.right.equalTo(self.contentView.snp.right).offset(-16)
        }
        exampleLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.translationLabel.snp.bottom).offset(11)
            make.left.equalTo(self.contentView.snp.left).offset(21)
            make.right.equalTo(self.contentView.snp.right).offset(-16)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-12)
        }
    }

    private func updateLayout(isExampleHidden: Bool) {
        exampleLabel.isHidden = isExampleHidden
        exampleLabel.snp.updateConstraints { make -> Void in
            make.top.equalTo(self.translationLabel.snp.bottom).offset(isExampleHidden ? 0 : 11)
        }
    }
}

private final class SectionHeaderView: UITableViewHeaderFooterView {

    private let titleLabel = UILabel()
    private let wordclassLabel = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(title: String, wordclass: String, theme: Theme) {
        titleLabel.text = title
        titleLabel.textColor = theme.textColor
        wordclassLabel.text = wordclass
        wordclassLabel.textColor = theme.textColor

        if title.isEmpty && !wordclass.isEmpty {
            updateConstraintsForWordclassLabelCase()
        } else {
            updateConstraintsForTitleAndWordclassLabelCase()
        }
    }

    private func initViews() {
        initTitleLabel()
        initWordclassLabel()
        setConstraints()
    }

    private func initTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        contentView.addSubview(titleLabel)
    }

    private func initWordclassLabel() {
        wordclassLabel.font = .italicSystemFont(ofSize: 17)
        contentView.addSubview(wordclassLabel)
    }

    private func updateConstraintsForWordclassLabelCase() {
        wordclassLabel.snp.updateConstraints { make -> Void in
            make.top.equalTo(contentView.snp.top).offset(8)
        }
    }

    private func updateConstraintsForTitleAndWordclassLabelCase() {
        wordclassLabel.snp.updateConstraints { make -> Void in
            make.top.equalTo(contentView.snp.top).offset(38)
        }
    }

    private func setConstraints() {
        titleLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(contentView.snp.top).offset(4)
            make.left.equalTo(contentView.snp.left).offset(22)
            make.right.equalTo(contentView.snp.right).offset(-22)
        }
        wordclassLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(contentView.snp.top).offset(38)
            make.left.equalTo(contentView.snp.left).offset(22)
            make.right.equalTo(contentView.snp.right).offset(-22)
        }
    }
}
