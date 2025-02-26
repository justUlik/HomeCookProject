//
//  AddressChooseViewModel.swift
//  Domashka
//
//  Created by Ulyana Eskova on 26.01.2025.
//

import Foundation
import MapKit

final class AddressChooseViewModel {
    var selectedAddress: String = "Москва, Россия"
    var selectedCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173)
    
    func isSupportedAddress(coordinate: CLLocationCoordinate2D) -> Bool {
        let supportedRegions = [
            MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173), latitudinalMeters: 10000, longitudinalMeters: 10000)
        ]

        return supportedRegions.contains { region in
            let center = region.center
            let latRange = (center.latitude - region.span.latitudeDelta / 2)...(center.latitude + region.span.latitudeDelta / 2)
            let lonRange = (center.longitude - region.span.longitudeDelta / 2)...(center.longitude + region.span.longitudeDelta / 2)

            return latRange.contains(coordinate.latitude) && lonRange.contains(coordinate.longitude)
        }
    }
}
