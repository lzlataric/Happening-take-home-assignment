//
//  MapService.swift
//  Betshops
//
//  Created by Luka on 04.05.2024..
//

import Foundation
import Combine

class MapService {
    
    func fetchBetshops(lat1: Double, lng1: Double, lat2: Double, lng2: Double) -> AnyPublisher<BetshopResponseModel, APIError> {
        guard let url = URL(string: Assets.URLS.betshops + "\(lat1),\(lng1),\(lat2),\(lng2)") else {
            return Fail(error: APIError.reqestFailed(description: Assets.ErrorText.invalidURL))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { error in
                return APIError.reqestFailed(description: error.localizedDescription)
            }
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                    let statusCode = (output.response as? HTTPURLResponse)?.statusCode ?? -1
                    throw APIError.invalidStatusCode(statusCode: statusCode)
                }
                return output.data
            }
            .decode(type: BetshopResponseModel.self, decoder: JSONDecoder())
            .mapError { error in
                if let apiError = error as? APIError {
                    return apiError
                } else if let _ = error as? DecodingError {
                    return APIError.jsonParsingError
                } else {
                    return APIError.unknownError(error: error)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
