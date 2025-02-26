import UIKit
import MapKit

final class AddressChooseOnMapController: UIViewController, MKMapViewDelegate {
    private var suggestionsView: AddressSuggestionsView?
    var addressInput = AddressInputView()
    let viewModel = AddressChooseViewModel()
    var draggableAnnotation: MKPointAnnotation!
    
    private struct Constants {
        static let addressInputText: String = "Введите адрес"
        static let draggableAnnotationText: String = "Выберите адрес"
    }
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureMap()
        
        
        addPin(at: viewModel.selectedCoordinate, withAddress: Constants.draggableAnnotationText)
        
        addressInput.onStartEditing = { [weak self] in
            self?.showSuggestionsView()
        }
        
        addressInput.onButtonPressed = { [weak self] in
            self?.navigateToMainMenu()
        }
    }
    
    private func navigateToMainMenu() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func configureUI() {
        view.addSubview(mapView)
        view.addSubview(addressInput)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        addressInput.pinHorizontal(to: view)
        addressInput.pinBottom(to: view.bottomAnchor, 0)
    }
    
    private func configureMap() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        let region = MKCoordinateRegion(center: viewModel.selectedCoordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    private func addPin(at coordinate: CLLocationCoordinate2D, withAddress address: String) {
        if draggableAnnotation == nil {
            draggableAnnotation = MKPointAnnotation()
        }
        
        mapView.removeAnnotation(draggableAnnotation)
        
        draggableAnnotation.coordinate = coordinate
        draggableAnnotation.title = address
        
        mapView.addAnnotation(draggableAnnotation)
        
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }

    
    private func showSuggestionsView() {
        let suggestionsView = AddressSuggestionsView()
        view.addSubview(suggestionsView)
        suggestionsView.pinHorizontal(to: view)
        suggestionsView.pinBottom(to: view.bottomAnchor, 0)
        
        suggestionsView.onAddressSelected = { [weak self] address in
            self?.addressInput.updateAddress(address.placemark.title ?? "Неизвестный адрес")
            self?.addressInput.isHidden = false
            
            self?.addPin(at: address.placemark.coordinate, withAddress: address.placemark.title ?? "Неизвестный адрес")
                    
            
            self?.viewModel.selectedCoordinate = address.placemark.coordinate
            self?.reverseGeocode(coordinate: address.placemark.coordinate)
            
           
            suggestionsView.removeFromSuperview()
        }
        
        self.suggestionsView = suggestionsView
        addressInput.isHidden = true
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let reuseId = "draggablePin"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView?.canShowCallout = true
            annotationView?.isDraggable = true
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange dragState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if dragState == .dragging {
            if let annotation = view.annotation {
                mapView.setCenter(annotation.coordinate, animated: true)
            }
        }
        
        if dragState == .ending {
            if let annotation = view.annotation {
                viewModel.selectedCoordinate = annotation.coordinate
                reverseGeocode(coordinate: annotation.coordinate)
            }
        }
    }
    
    private func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let placemark = placemarks?.first {
                let address = placemark.name ?? "Неизвестный адрес"
                addPin(at: coordinate, withAddress: address)
                self.addressInput.updateAddress(address)
                if !self.viewModel.isSupportedAddress(coordinate: coordinate) {
                    self.addressInput.showUnsupportedWarning()
                    self.addressInput.setButtonState(isActive: false)
                    return
                }
                
                self.viewModel.selectedAddress = address
                self.addressInput.setButtonState(isActive: true)
                self.addressInput.hideUnsupportedWarning()
            }
        }
    }

}
