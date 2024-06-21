//
//  VisibilitySwitchView.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import Combine
import ComposableArchitecture
import UIKit

struct ShowButtonParams {
    let show: String
    let hide: String
}

final class ShowButtonView: UIView {

    private let params: ShowButtonParams
    private let viewStore: ShowButtonViewStore
    private var cancellables: Set<AnyCancellable> = []
    private let toggle = UIButton()

    init(params: ShowButtonParams,
         store: ShowButtonStore) {
        self.params = params
        self.viewStore = ViewStore(store, observe: { $0 })
        super.init(frame: .zero)
        initViews()
        bindToStore()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindToStore() {
        viewStore.publisher.sink(receiveValue: { [weak self] state in
            self?.set(state: state)
        }).store(in: &cancellables)
    }

    private func set(state: ShowButton.State) {
        toggle.setTitle(state.mode == .hide ? params.hide : params.show, for: .normal)
        toggle.setTitleColor(state.isEnabled ? .systemBlue : .systemGray, for: .normal)
        toggle.isEnabled = state.isEnabled
    }

    @objc
    private func onToggleTap() {
        viewStore.send(.toggle)
    }

    private func initViews() {
        addSubview(toggle)
        toggle.addTarget(self, action: #selector(onToggleTap), for: .touchUpInside)
        toggle.backgroundColor = .clear
        toggle.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        toggle.setTitle(params.show, for: .normal)
        toggle.setTitleColor(.systemGray, for: .normal)
        toggle.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}
