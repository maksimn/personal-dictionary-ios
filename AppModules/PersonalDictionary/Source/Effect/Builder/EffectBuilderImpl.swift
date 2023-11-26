//
//  EffectBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 25.11.2023.
//

struct EffectBuilderImpl: EffectBuilder {

    func build() -> EffectHolder {
        let effect = EffectImpl()

        return EffectHolderImpl(
            effect: effect,
            newWordStream: WordStreamImpl.instance,
            updatedWordStream: WordStreamImpl.instance,
            removedWordStream: WordStreamImpl.instance
        )
    }
}
