//
//  DataTypes+Cuckoo.
//  PersonalDictionaryTests
//
//  Created by Maxim Ivanov on 15.03.2022.
//

import CoreModule
import Cuckoo

extension Http: Matchable {

    public var matcher: ParameterMatcher<Http> {
        ParameterMatcher<Http>()
    }
}

extension Data: Matchable {

    public var matcher: ParameterMatcher<Data> {
        ParameterMatcher<Data>()
    }
}
