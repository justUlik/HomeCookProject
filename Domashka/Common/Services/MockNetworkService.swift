//
//  MockNetworkService.swift
//  Domashka
//
//  Created by Ulyana Eskova on 18.02.2025.
//

import MapKit
import Foundation

final class MockNetworkService {
    static func saveUserAddress(userId: String, address: String, coordinate: CLLocationCoordinate2D, completion: @escaping (String) -> Void) {
        // Simulate a network delay, then always return success
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            // Always return success
            completion("Address saved successfully")
        }
    }
}
