//
//  MapViewModel.swift
//  Betshops
//
//  Created by Luka on 04.05.2024..
//

import Foundation
import Combine
import MapKit

class MapViewModel {
    private var mapService: MapService
    
    @Published var betshops: [Betshop] = []
    @Published var errorMessage: String?
    private let regionSubject = PassthroughSubject<MKCoordinateRegion, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.mapService = MapService()
        
        regionSubject
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] region in
                guard let self = self else { return }
                self.fetchBetshopsForLocation(center: region.center, span: region.span)
            }
            .store(in: &cancellables)
    }
    
    private func fetchBetshops(lat1: Double, lng1: Double, lat2: Double, lng2: Double) {
        mapService.fetchBetshops(lat1: lat1, lng1: lng1, lat2: lat2, lng2: lng2)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.handleError(error: error)
                    break
                }
            } receiveValue: { [weak self] betshops in
                guard let self = self else { return }
                self.betshops = betshops.betshops
            }
            .store(in: &cancellables)
    }
    
    func updateRegion(region: MKCoordinateRegion) {
            regionSubject.send(region)
        }
    
    private func fetchBetshopsForLocation(center: CLLocationCoordinate2D, span: MKCoordinateSpan) {
        let lat1 = center.latitude + (span.latitudeDelta / 2.0)
        let lat2 = center.latitude - (span.latitudeDelta / 2.0)
        let lng2 = center.longitude - (span.longitudeDelta / 2.0)
        let lng1 = center.longitude + (span.longitudeDelta / 2.0)
        fetchBetshops(lat1: lat1, lng1: lng1, lat2: lat2, lng2: lng2)
    }
    
    private func handleError(error: APIError) {
        errorMessage = error.customDescription
    }
}
