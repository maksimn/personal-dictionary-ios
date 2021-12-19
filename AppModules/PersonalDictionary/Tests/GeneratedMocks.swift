// MARK: - Mocks generated from file: PersonalDictionary/PersonalDictionary/Repository/Lang/LangRepository.swift at 2021-12-19 16:22:25 +0000

//
//  LangRepository.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import Cuckoo
@testable import PersonalDictionary


 class MockLangRepository: LangRepository, Cuckoo.ProtocolMock {
    
     typealias MocksType = LangRepository
    
     typealias Stubbing = __StubbingProxy_LangRepository
     typealias Verification = __VerificationProxy_LangRepository

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: LangRepository?

     func enableDefaultImplementation(_ stub: LangRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
     var allLangs: [Lang] {
        get {
            return cuckoo_manager.getter("allLangs",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.allLangs)
        }
        
    }
    
    
    
     var sourceLang: Lang {
        get {
            return cuckoo_manager.getter("sourceLang",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.sourceLang)
        }
        
        set {
            cuckoo_manager.setter("sourceLang",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.sourceLang = newValue)
        }
        
    }
    
    
    
     var targetLang: Lang {
        get {
            return cuckoo_manager.getter("targetLang",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.targetLang)
        }
        
        set {
            cuckoo_manager.setter("targetLang",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.targetLang = newValue)
        }
        
    }
    

    

    

	 struct __StubbingProxy_LangRepository: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var allLangs: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockLangRepository, [Lang]> {
	        return .init(manager: cuckoo_manager, name: "allLangs")
	    }
	    
	    
	    var sourceLang: Cuckoo.ProtocolToBeStubbedProperty<MockLangRepository, Lang> {
	        return .init(manager: cuckoo_manager, name: "sourceLang")
	    }
	    
	    
	    var targetLang: Cuckoo.ProtocolToBeStubbedProperty<MockLangRepository, Lang> {
	        return .init(manager: cuckoo_manager, name: "targetLang")
	    }
	    
	    
	}

	 struct __VerificationProxy_LangRepository: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var allLangs: Cuckoo.VerifyReadOnlyProperty<[Lang]> {
	        return .init(manager: cuckoo_manager, name: "allLangs", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var sourceLang: Cuckoo.VerifyProperty<Lang> {
	        return .init(manager: cuckoo_manager, name: "sourceLang", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var targetLang: Cuckoo.VerifyProperty<Lang> {
	        return .init(manager: cuckoo_manager, name: "targetLang", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}
}

 class LangRepositoryStub: LangRepository {
    
    
     var allLangs: [Lang] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([Lang]).self)
        }
        
    }
    
    
     var sourceLang: Lang {
        get {
            return DefaultValueRegistry.defaultValue(for: (Lang).self)
        }
        
        set { }
        
    }
    
    
     var targetLang: Lang {
        get {
            return DefaultValueRegistry.defaultValue(for: (Lang).self)
        }
        
        set { }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: PersonalDictionary/PersonalDictionary/Repository/WordList/WordListRepository.swift at 2021-12-19 16:22:25 +0000

//
//  WordListRepository.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 06.10.2021.
//

import Cuckoo
@testable import PersonalDictionary

import RxSwift


 class MockWordListFetcher: WordListFetcher, Cuckoo.ProtocolMock {
    
     typealias MocksType = WordListFetcher
    
     typealias Stubbing = __StubbingProxy_WordListFetcher
     typealias Verification = __VerificationProxy_WordListFetcher

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: WordListFetcher?

     func enableDefaultImplementation(_ stub: WordListFetcher) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
     var wordList: [WordItem] {
        get {
            return cuckoo_manager.getter("wordList",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.wordList)
        }
        
    }
    

    

    

	 struct __StubbingProxy_WordListFetcher: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var wordList: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWordListFetcher, [WordItem]> {
	        return .init(manager: cuckoo_manager, name: "wordList")
	    }
	    
	    
	}

	 struct __VerificationProxy_WordListFetcher: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var wordList: Cuckoo.VerifyReadOnlyProperty<[WordItem]> {
	        return .init(manager: cuckoo_manager, name: "wordList", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}
}

 class WordListFetcherStub: WordListFetcher {
    
    
     var wordList: [WordItem] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([WordItem]).self)
        }
        
    }
    

    

    
}



 class MockWordItemCUDOperations: WordItemCUDOperations, Cuckoo.ProtocolMock {
    
     typealias MocksType = WordItemCUDOperations
    
     typealias Stubbing = __StubbingProxy_WordItemCUDOperations
     typealias Verification = __VerificationProxy_WordItemCUDOperations

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: WordItemCUDOperations?

     func enableDefaultImplementation(_ stub: WordItemCUDOperations) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     func add(_ wordItem: WordItem) -> Completable {
        
    return cuckoo_manager.call("add(_: WordItem) -> Completable",
            parameters: (wordItem),
            escapingParameters: (wordItem),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.add(wordItem))
        
    }
    
    
    
     func update(_ wordItem: WordItem) -> Completable {
        
    return cuckoo_manager.call("update(_: WordItem) -> Completable",
            parameters: (wordItem),
            escapingParameters: (wordItem),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.update(wordItem))
        
    }
    
    
    
     func remove(with wordItemId: WordItem.Id) -> Completable {
        
    return cuckoo_manager.call("remove(with: WordItem.Id) -> Completable",
            parameters: (wordItemId),
            escapingParameters: (wordItemId),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.remove(with: wordItemId))
        
    }
    

	 struct __StubbingProxy_WordItemCUDOperations: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func add<M1: Cuckoo.Matchable>(_ wordItem: M1) -> Cuckoo.ProtocolStubFunction<(WordItem), Completable> where M1.MatchedType == WordItem {
	        let matchers: [Cuckoo.ParameterMatcher<(WordItem)>] = [wrap(matchable: wordItem) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockWordItemCUDOperations.self, method: "add(_: WordItem) -> Completable", parameterMatchers: matchers))
	    }
	    
	    func update<M1: Cuckoo.Matchable>(_ wordItem: M1) -> Cuckoo.ProtocolStubFunction<(WordItem), Completable> where M1.MatchedType == WordItem {
	        let matchers: [Cuckoo.ParameterMatcher<(WordItem)>] = [wrap(matchable: wordItem) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockWordItemCUDOperations.self, method: "update(_: WordItem) -> Completable", parameterMatchers: matchers))
	    }
	    
	    func remove<M1: Cuckoo.Matchable>(with wordItemId: M1) -> Cuckoo.ProtocolStubFunction<(WordItem.Id), Completable> where M1.MatchedType == WordItem.Id {
	        let matchers: [Cuckoo.ParameterMatcher<(WordItem.Id)>] = [wrap(matchable: wordItemId) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockWordItemCUDOperations.self, method: "remove(with: WordItem.Id) -> Completable", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_WordItemCUDOperations: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func add<M1: Cuckoo.Matchable>(_ wordItem: M1) -> Cuckoo.__DoNotUse<(WordItem), Completable> where M1.MatchedType == WordItem {
	        let matchers: [Cuckoo.ParameterMatcher<(WordItem)>] = [wrap(matchable: wordItem) { $0 }]
	        return cuckoo_manager.verify("add(_: WordItem) -> Completable", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func update<M1: Cuckoo.Matchable>(_ wordItem: M1) -> Cuckoo.__DoNotUse<(WordItem), Completable> where M1.MatchedType == WordItem {
	        let matchers: [Cuckoo.ParameterMatcher<(WordItem)>] = [wrap(matchable: wordItem) { $0 }]
	        return cuckoo_manager.verify("update(_: WordItem) -> Completable", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func remove<M1: Cuckoo.Matchable>(with wordItemId: M1) -> Cuckoo.__DoNotUse<(WordItem.Id), Completable> where M1.MatchedType == WordItem.Id {
	        let matchers: [Cuckoo.ParameterMatcher<(WordItem.Id)>] = [wrap(matchable: wordItemId) { $0 }]
	        return cuckoo_manager.verify("remove(with: WordItem.Id) -> Completable", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class WordItemCUDOperationsStub: WordItemCUDOperations {
    

    

    
     func add(_ wordItem: WordItem) -> Completable  {
        return DefaultValueRegistry.defaultValue(for: (Completable).self)
    }
    
     func update(_ wordItem: WordItem) -> Completable  {
        return DefaultValueRegistry.defaultValue(for: (Completable).self)
    }
    
     func remove(with wordItemId: WordItem.Id) -> Completable  {
        return DefaultValueRegistry.defaultValue(for: (Completable).self)
    }
    
}



 class MockWordListRepository: WordListRepository, Cuckoo.ProtocolMock {
    
     typealias MocksType = WordListRepository
    
     typealias Stubbing = __StubbingProxy_WordListRepository
     typealias Verification = __VerificationProxy_WordListRepository

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: WordListRepository?

     func enableDefaultImplementation(_ stub: WordListRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
     var wordList: [WordItem] {
        get {
            return cuckoo_manager.getter("wordList",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.wordList)
        }
        
    }
    

    

    
    
    
     func add(_ wordItem: WordItem) -> Completable {
        
    return cuckoo_manager.call("add(_: WordItem) -> Completable",
            parameters: (wordItem),
            escapingParameters: (wordItem),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.add(wordItem))
        
    }
    
    
    
     func update(_ wordItem: WordItem) -> Completable {
        
    return cuckoo_manager.call("update(_: WordItem) -> Completable",
            parameters: (wordItem),
            escapingParameters: (wordItem),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.update(wordItem))
        
    }
    
    
    
     func remove(with wordItemId: WordItem.Id) -> Completable {
        
    return cuckoo_manager.call("remove(with: WordItem.Id) -> Completable",
            parameters: (wordItemId),
            escapingParameters: (wordItemId),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.remove(with: wordItemId))
        
    }
    

	 struct __StubbingProxy_WordListRepository: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var wordList: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWordListRepository, [WordItem]> {
	        return .init(manager: cuckoo_manager, name: "wordList")
	    }
	    
	    
	    func add<M1: Cuckoo.Matchable>(_ wordItem: M1) -> Cuckoo.ProtocolStubFunction<(WordItem), Completable> where M1.MatchedType == WordItem {
	        let matchers: [Cuckoo.ParameterMatcher<(WordItem)>] = [wrap(matchable: wordItem) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockWordListRepository.self, method: "add(_: WordItem) -> Completable", parameterMatchers: matchers))
	    }
	    
	    func update<M1: Cuckoo.Matchable>(_ wordItem: M1) -> Cuckoo.ProtocolStubFunction<(WordItem), Completable> where M1.MatchedType == WordItem {
	        let matchers: [Cuckoo.ParameterMatcher<(WordItem)>] = [wrap(matchable: wordItem) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockWordListRepository.self, method: "update(_: WordItem) -> Completable", parameterMatchers: matchers))
	    }
	    
	    func remove<M1: Cuckoo.Matchable>(with wordItemId: M1) -> Cuckoo.ProtocolStubFunction<(WordItem.Id), Completable> where M1.MatchedType == WordItem.Id {
	        let matchers: [Cuckoo.ParameterMatcher<(WordItem.Id)>] = [wrap(matchable: wordItemId) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockWordListRepository.self, method: "remove(with: WordItem.Id) -> Completable", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_WordListRepository: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var wordList: Cuckoo.VerifyReadOnlyProperty<[WordItem]> {
	        return .init(manager: cuckoo_manager, name: "wordList", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func add<M1: Cuckoo.Matchable>(_ wordItem: M1) -> Cuckoo.__DoNotUse<(WordItem), Completable> where M1.MatchedType == WordItem {
	        let matchers: [Cuckoo.ParameterMatcher<(WordItem)>] = [wrap(matchable: wordItem) { $0 }]
	        return cuckoo_manager.verify("add(_: WordItem) -> Completable", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func update<M1: Cuckoo.Matchable>(_ wordItem: M1) -> Cuckoo.__DoNotUse<(WordItem), Completable> where M1.MatchedType == WordItem {
	        let matchers: [Cuckoo.ParameterMatcher<(WordItem)>] = [wrap(matchable: wordItem) { $0 }]
	        return cuckoo_manager.verify("update(_: WordItem) -> Completable", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func remove<M1: Cuckoo.Matchable>(with wordItemId: M1) -> Cuckoo.__DoNotUse<(WordItem.Id), Completable> where M1.MatchedType == WordItem.Id {
	        let matchers: [Cuckoo.ParameterMatcher<(WordItem.Id)>] = [wrap(matchable: wordItemId) { $0 }]
	        return cuckoo_manager.verify("remove(with: WordItem.Id) -> Completable", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class WordListRepositoryStub: WordListRepository {
    
    
     var wordList: [WordItem] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([WordItem]).self)
        }
        
    }
    

    

    
     func add(_ wordItem: WordItem) -> Completable  {
        return DefaultValueRegistry.defaultValue(for: (Completable).self)
    }
    
     func update(_ wordItem: WordItem) -> Completable  {
        return DefaultValueRegistry.defaultValue(for: (Completable).self)
    }
    
     func remove(with wordItemId: WordItem.Id) -> Completable  {
        return DefaultValueRegistry.defaultValue(for: (Completable).self)
    }
    
}

