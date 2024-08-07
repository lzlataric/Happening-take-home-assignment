//
//  APIErrors.swift
//  Betshops
//
//  Created by Luka on 04.05.2024..
//

import Foundation

enum APIError: Error {
    case jsonParsingError
    case reqestFailed(description: String)
    case invalidStatusCode(statusCode: Int)
    case unknownError(error: Error)
    
    var customDescription: String {
        switch self {
        case .jsonParsingError:
            return Assets.ErrorText.jSON
        case .reqestFailed(let description):
            return Assets.ErrorText.requestFailed + description
        case .invalidStatusCode(let statusCode):
            return Assets.ErrorText.statusCode + String(statusCode)
        case .unknownError(let error):
            return Assets.ErrorText.unknownError + error.localizedDescription
        }
    }
}
