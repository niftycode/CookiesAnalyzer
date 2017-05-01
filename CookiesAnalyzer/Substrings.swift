//
//  Substrings.swift
//  CookiesAnalyzer
//
//  Created by Bodo Schönfeld on 17/03/16.
//  Copyright © 2016 Bodo Schönfeld. All rights reserved.
//

import Foundation

extension String {
    
    // string length
    var len: Int {
        return self.characters.count
    }
    
    // return character at position n
    subscript(n: Int) -> String {
        if n<0 || n>self.len {
            return ""
        } else {
            let idx = self.index(self.startIndex, offsetBy: n)
            return String(describing: idx)
        }
    }    
}
