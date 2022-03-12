//
//  TextLabel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

import UIKit

/// Тип для параметризации представления для отображения текста.
struct TextLabelParams {

    /// Цвет текста
    let textColor: UIColor

    /// Шрифт
    let font: UIFont

    /// Текст для отображения в представлении
    let text: String
}

/// Представление для отображения текста.
final class TextLabel: UIView {

    private let label = UILabel()
    private let params: TextLabelParams

    /// Инициализатор представления.
    /// - Parameters:
    ///  - params: параметры представления.
    init(params: TextLabelParams) {
        self.params = params
        super.init(frame: .zero)
        initLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initLabel() {
        label.textColor = params.textColor
        label.font = params.font
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = params.text
        addSubview(label)
        label.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
    }
}
