//
//  CounterView.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import Combine
import ComposableArchitecture
import UIKit

final class CounterView: UIView {

    private let template: String
    private let label = UILabel()
    private let store: CounterStore
    private let theme: Theme
    private var cancellables: Set<AnyCancellable> = []

    init(template: String,
         store: CounterStore,
         theme: Theme) {
        self.template = template
        self.store = store
        self.theme = theme
        super.init(frame: .zero)
        initLabel()
        bindToStore()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindToStore() {
        store.publisher
            .map { [weak self] count in
                guard let self = self else { return "" }

                return self.counterText(count)
            }
            .assign(to: \.text, on: label)
            .store(in: &self.cancellables)
    }

    private func initLabel() {
        addSubview(label)
        label.text = counterText(0)
        label.textColor = theme.secondaryTextColor
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.isUserInteractionEnabled = false
        label.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
    }

    private func counterText(_ count: Int) -> String {
        String(format: self.template, count)
    }
}
