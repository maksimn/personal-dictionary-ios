//
//  EffectBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 25.11.2023.
//

struct EffectBuilderImpl: EffectBuilder {

    func build() -> EffectHolder {
        return EffectHolderImpl()
    }
}
