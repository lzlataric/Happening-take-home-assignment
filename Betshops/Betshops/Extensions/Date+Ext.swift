//
//  Date+Ext.swift
//  Betshops
//
//  Created by Luka on 04.05.2024..
//

import Foundation

extension Date {
    func currentTimeFormatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}
