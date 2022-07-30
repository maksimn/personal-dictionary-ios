//
//  CounterView.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxSwift
import UIKit

final class CounterView: UIView {

    private let viewModel: CounterViewModel

    private let disposeBag = DisposeBag()

    private let label = UILabel()

    private let text: String

    init(viewModel: CounterViewModel,
         text: String) {
        self.viewModel = viewModel
        self.text = text
        super.init(frame: .zero)
        initLabel()
        bindToViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initLabel() {
        addSubview(label)
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.isUserInteractionEnabled = false
        label.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
    }

    private func bindToViewModel() {
        viewModel.count.subscribe(onNext: { [weak self] count in
            guard let self = self else { return }

            self.label.text = self.text + String(count)
        }).disposed(by: disposeBag)
    }
}
