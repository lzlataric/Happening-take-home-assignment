//
//  Assets.swift
//  Betshops
//
//  Created by Luka on 04.05.2024..
//

import Foundation
import UIKit

struct Assets {
    
    struct URLS {
        static var betshops = "https://interview.superology.dev/betshops?boundingBox="
    }
    
    struct Text {
        static var errorOccured = "Error occured"
        static var unknownError = "Unknown error"
        static var cancel = "Cancel"
        static var route = "Route"
        static var opensTommorow = "Opens tomorrow at "
        static var openNow = "Open now until "
    }
    
    struct ErrorText {
        static var jSON = "Failed to parse JSON"
        static var requestFailed = "Request failed: "
        static var statusCode = "Invalid status code: "
        static var unknownError = "Unknown error occured: "
        static var invalidURL = "Invalid URL"
    }
    
    struct Colors {
        static var blue = UIColor(named: "PinBlue")
        static var green = UIColor(named: "OpenHours")
    }
    
    struct Images {
        static var close = UIImage(named: "Close")
        static var location = UIImage(named: "Location")
        static var defaultPin = UIImage(named: "Pin Default")
        static var selectedPin = UIImage(named: "Pin Selected")
    }
}
