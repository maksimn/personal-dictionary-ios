//
//  TextLabelBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

final class TextLabelBuilderImpl: TextLabelBuilder {

    private let params: TextLabelParams

    init(params: TextLabelParams) {
        self.params = params
    }

    func build() -> TextLabel {
        TextLabel(params: params)
    }
}
