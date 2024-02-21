//
//  Extensions.swift
//  Recipe Realm
//
//  Created by Vatsal Patel  on 2/20/24.
//

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
