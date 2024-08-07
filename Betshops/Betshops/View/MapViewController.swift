//
//  MapViewController.swift
//  Betshops
//
//  Created by Luka on 04.05.2024..
//

import UIKit
import SnapKit
import MapKit
import CoreLocation
import Combine

class MapViewController: UIViewController {
    private var mapView = MKMapView()
    private let viewModel = MapViewModel()
    private let detailView = BetshopDetailsView(frame: .zero)
    
    private let locationManager: CLLocationManager = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    private var isLocationShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        configureLocationManager()
        viewModelSubscriptions()
        configureDetailView()
    }
    
    func showErrorAlert(error: String) {
        let alertController = UIAlertController(
            title: Assets.Text.errorOccured,
            message: error,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: Assets.Text.cancel, style: .cancel) { _ in }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: Subscriptions
extension MapViewController {
    private func viewModelSubscriptions() {
        viewModel.$betshops
            .sink { [weak self] shops in
                guard let self = self else { return }
                self.showMapAnnotations(shops: shops)
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .sink { [weak self] errorMessage in
                guard let self = self else { return }
                showErrorAlert(error: errorMessage ?? Assets.Text.unknownError)
            }
            .store(in: &cancellables)
    }
}

//MARK: User location
extension MapViewController: CLLocationManagerDelegate {
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            showDefaultLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.last {
            if !isLocationShown {
                let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                mapView.setRegion(region, animated: true)
                isLocationShown = true
            }
        }
    }
    
    private func showDefaultLocation() {
        let center = CLLocationCoordinate2D(latitude: 48.137154, longitude: 11.576124)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
}

//MARK: Map
extension MapViewController: MKMapViewDelegate {
    private func configureMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.edges.equalToSuperview()
        }
    }
    
    func showMapAnnotations(shops: [Betshop]) {
        mapView.removeAnnotations(mapView.annotations)
        let annotations = shops.map { shop -> CustomAnnotation in
            let annotation = CustomAnnotation(
                coordinate: CLLocationCoordinate2D(latitude: shop.location.lat, longitude: shop.location.lng),
                annotationType: .defaultPin,
                betshop: shop)
            return annotation
        }
        mapView.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let _ = annotation as? MKClusterAnnotation {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier, for: annotation) as! MKMarkerAnnotationView
            annotationView.markerTintColor = Assets.Colors.blue
            return annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let customAnnotationView = view as? CustomAnnotationView else { return }
        DispatchQueue.main.async {
            UIView.transition(with: customAnnotationView,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                customAnnotationView.image = AnnotationType.selectedPin.image()
                customAnnotationView.frame.size = CGSize(width: 40, height: 50)
            }, completion: nil)
        }
        
        guard let annotation = customAnnotationView.annotation as? CustomAnnotation else { return }
        detailView.setData(betshop: annotation.betshop)
        animateShowDetailView()
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let customAnnotationView = view as? CustomAnnotationView else { return }
        customAnnotationView.image = AnnotationType.defaultPin.image()
        customAnnotationView.frame.size = CGSize(width: 30, height: 40)
        hideDetailView()
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        viewModel.updateRegion(region: mapView.region)
    }
}

//MARK: Details View
extension MapViewController {
    private func configureDetailView() {
        view.addSubview(detailView)
        detailView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(220)
        }
        
        detailView.close = { [weak self] in
            guard let self = self else { return }
            if let selectedAnnotation = mapView.selectedAnnotations.first {
                mapView.deselectAnnotation(selectedAnnotation, animated: true)
            }
            self.hideDetailView()
        }
        
        detailView.route = { betshop in
            let coordinate = CLLocationCoordinate2D(latitude: betshop.location.lat, longitude: betshop.location.lng)
            let placemark = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = betshop.name
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
    }
    
    private func animateShowDetailView() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveLinear], animations: { [weak self] in
            guard let self = self else { return }
            self.detailView.snp.remakeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.left.right.equalToSuperview()
                make.height.equalTo(220)
                self.view.layoutIfNeeded()
            }
        }, completion: nil)
    }
    
    private func hideDetailView() {
        self.detailView.snp.remakeConstraints { (make) in
            make.top.equalTo(view.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(220)
            self.view.layoutIfNeeded()
        }
    }
}
