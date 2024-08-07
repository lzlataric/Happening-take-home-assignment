//
//  String+Ext.swift
//  Betshops
//
//  Created by Luka on 05.05.2024..
//

import Foundation

extension String {
    func removeWhitespaceIfFirst() -> String {
        var string = self
        if self.hasPrefix(" ") {
            string.removeFirst()
            return string
        } else {
            return self
        }
    }
}
