//
//  CustomAnnotation.swift
//  Betshops
//
//  Created by Luka on 04.05.2024..
//

import Foundation
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var annotationType: AnnotationType
    var betshop: Betshop
    
    init(coordinate: CLLocationCoordinate2D, annotationType: AnnotationType, betshop: Betshop) {
        self.coordinate = coordinate
        self.annotationType = annotationType
        self.betshop = betshop
    }
}

class CustomAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let customAnnotation = newValue as? CustomAnnotation else { return }
            guard let image = customAnnotation.annotationType.image() else { return }
            self.image = image
            frame.size = CGSize(width: 30, height: 40)
            clusteringIdentifier = "clusterId"
        }
    }
}

enum AnnotationType {
    case defaultPin
    case selectedPin
    
    func image() -> UIImage? {
        switch self {
        case .defaultPin:
            return Assets.Images.defaultPin
        case .selectedPin:
            return Assets.Images.selectedPin
        }
    }
}

