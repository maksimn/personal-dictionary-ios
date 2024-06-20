//
//  LangPickerUDFImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import CoreModule
import UDF

final class LangPickerUDFImpl: LangPickerUDF, ServiceComponent {
    
    var props = LangPickerState() {
        didSet {
            guard let setter else {
                return logger.log("LangPickerView cannot be updated because the reference is nil", level: .warn)
            }
            
            setter.setViewState(props)
        }
    }
    
    var disposer = Disposer()
    
    private let store: Store<LangPickerState>
    private var setterBlock: () -> LangPickerStateSetter?
    private let logger: Logger
    
    private weak var setter: LangPickerStateSetter?
    
    init(store: Store<LangPickerState>, setterBlock: @escaping () -> LangPickerStateSetter?, logger: Logger) {
        self.store = store
        self.setterBlock = setterBlock
        self.logger = logger
    }

    func onSelect(_ lang: Lang) {
        let langType = store.state.langType
        
        store.dispatch(LangPickerAction.langSelected(lang, langType))
    }
}
