//
//  MessageBoxView.swift
//  SharedFeature
//
//  Created by Maxim Ivanov on 31.08.2023.
//

import Combine
import Toast
import UIKit

final class MessageBoxView: UIView {

    private let viewModel: MessageBoxViewModel
    private let duration: Int

    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: MessageBoxViewModel, duration: Int) {
        self.viewModel = viewModel
        self.duration = duration
        super.init(frame: .zero)
        bindToViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindToViewModel() {
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.onNext(state: $0)
            }.store(in: &cancellables)
    }

    private func onNext(state: MessageBoxState) {
        if state.isHidden {
            return
        }

        guard let view = findViewController()?.view else { return }
        let point = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * CGFloat(0.8))

        view.makeToast(state.text, duration: .init(duration), point: point, title: nil, image: nil, completion: nil)
    }
}
