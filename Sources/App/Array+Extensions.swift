//
//  Array+Extensions.swift
//  Hello
//
//  Created by COBE on 26/02/2017.
//
//

import Foundation

extension Array {
    
    subscript(safe index: Int)-> Element? {
        get {
            return index > 0 && index < self.count ? self[index] : nil
        }
    }
    
}
