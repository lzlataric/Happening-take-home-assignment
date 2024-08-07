//
//  Shops.swift
//  Betshops
//
//  Created by Luka on 04.05.2024..
//

import Foundation

struct BetshopResponseModel: Codable {
    let count: Int
    let betshops: [Betshop]
}

struct Betshop: Codable {
    let name: String
    let location: Location
    let id: Int
    let county: String
    let cityID: Int
    let city: String
    let address: String
    let openingTime = "08:00"
    let closingTime = "16:00"
    
    enum CodingKeys: String, CodingKey {
        case name
        case location
        case id
        case county
        case cityID = "city_id"
        case city
        case address
    }
}

struct Location: Codable {
    let lng: Double
    let lat: Double
}


