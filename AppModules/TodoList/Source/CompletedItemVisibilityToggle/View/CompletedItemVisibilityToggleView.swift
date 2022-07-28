//
//  CompletedItemVisibilityToggleView.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxSwift
import UIKit

struct CompletedItemVisibilityToggleViewParams {
    let show: String
    let hide: String
    let active: UIColor
    let disabled: UIColor
}

final class CompletedItemVisibilityToggleView: UIView {

    private let button = UIButton()

    private let viewModel: CompletedItemVisibilityToggleViewModel

    private let params: CompletedItemVisibilityToggleViewParams

    private let disposeBag = DisposeBag()

    init(viewModel: CompletedItemVisibilityToggleViewModel,
         params: CompletedItemVisibilityToggleViewParams) {
        self.viewModel = viewModel
        self.params = params
        super.init(frame: .zero)
        initViews()
        bindToViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initViews() {
        addSubview(button)
        button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitle("Показать", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
    }

    private func bindToViewModel() {
        viewModel.state.subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            let params = self.params

            self.button.isEnabled = !state.isEmpty
            self.button.setTitleColor(state.isEmpty ? params.disabled : params.active, for: .normal)
            self.button.setTitle(state.isVisible ? params.hide : params.show, for: .normal)
        }).disposed(by: disposeBag)
    }

    @objc
    private func onButtonTap() {
        let oldState = viewModel.state.value

        viewModel.state.accept(
            CompletedItemVisibilityToggleState(
                isVisible: !oldState.isVisible,
                isEmpty: oldState.isEmpty
            )
        )
    }
}
