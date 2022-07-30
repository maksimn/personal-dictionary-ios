//
//  NetwordIndicatorViewImpl.swift
//  SuperList
//
//  Created by Maxim Ivanov on 01.01.2022.
//

import SnapKit
import UIKit

final class NetworkIndicatorViewImpl: UIView, NetworkIndicatorView {

    var presenter: NetworkIndicatorPresenter?

    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    init() {
        super.init(frame: .zero)
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(visible: Bool) {
        visible ?
            activityIndicator.startAnimating() :
            activityIndicator.stopAnimating()
    }
}
