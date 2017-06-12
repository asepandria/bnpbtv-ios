//
//  StringExtension.swift
//  BPNBTV
//
//  Created by Raditya on 6/13/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import Foundation

extension String {
    func firstCharToUpper() -> String {
        if let firstCharacter = characters.first {
            return replacingCharacters(in: startIndex..<index(after: startIndex), with: String(firstCharacter).uppercased())
        }
        return ""
    }
}
