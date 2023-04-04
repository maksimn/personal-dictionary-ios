//
//  NetworkIndicatorView.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import Combine
import ComposableArchitecture
import SnapKit
import UIKit

final class NetworkIndicatorView: UIView {

    private let viewStore: ViewStoreOf<NetworkIndicator>
    private var cancellables: Set<AnyCancellable> = []
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    init(store: StoreOf<NetworkIndicator>) {
        self.viewStore = ViewStore(store)
        super.init(frame: .zero)
        initViews()
        bindToStore()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindToStore() {
        viewStore.publisher.sink(receiveValue: { [weak self] state in
            self?.set(visible: state.isVisible)
        }).store(in: &cancellables)
    }

    private func initViews() {
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
    }

    private func set(visible: Bool) {
        if visible {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
