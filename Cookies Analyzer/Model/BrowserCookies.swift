//
//  BrowserCookies.swift
//  CookiesAnalyzer
//
//  Created by Bodo Schönfeld on 19/08/16.
//  Copyright © 2016 Bodo Schönfeld. All rights reserved.
//

import Foundation

struct BrowserCookies {
    
    var baseDomain: String
    var creationTime: String
    
    init(baseDomain: String, creationTime: String) {
        self.baseDomain = baseDomain
        self.creationTime = creationTime
    }
}
