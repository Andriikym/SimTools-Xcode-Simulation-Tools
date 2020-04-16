/**
*  SimTools
*  Copyright (c) Andrii Myk 2020
*  Licensed under the MIT license (see LICENSE file)
*/

import Cocoa
import MapKit

private class Marker: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

class LocationSelectionViewController: NSViewController {
    
    // MARK: - Private properties

    private var simManager = SimManager.shared

    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoLabel: NSTextField!
    @IBOutlet weak var coordinatesLabel: NSTextField!
    @IBOutlet weak var liveCheck: NSButton!
    
    // MARK: - Public properties

    private(set) var selectedLocation: CLLocationCoordinate2D?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        coordinatesLabel.stringValue = "Select point"
        infoLabel.stringValue = ""

        let recognizer = NSClickGestureRecognizer(target: self, action: #selector(handleSelection))
        mapView.addGestureRecognizer(recognizer)
    }
    
    
    // MARK: - Private
    
    @objc private func handleSelection(gestureReconizer: NSClickGestureRecognizer) {
        if gestureReconizer.state == NSGestureRecognizer.State.ended {
            let touchLocation = gestureReconizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            updateSelectedLocation(locationCoordinate)
        }
    }
    
    private func updateSelectedLocation(_ location: CLLocationCoordinate2D) {
        selectedLocation = location
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(Marker(coordinate: location))
        coordinatesLabel.stringValue = location.toString
        if liveCheck.state == .on {
            proceedLocation(location)
        }
    }
    
    private func proceedLocation(_ location: CLLocationCoordinate2D) {
        simManager.setLocationToBootedSimulators(location) { error in
            let text = error == nil ? "Location set to \(location.toString)" : error!.description
            self.infoLabel.stringValue = text
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onSetLocation(_ sender: Any) {
        guard let location = selectedLocation else {
            infoLabel.stringValue = "Select location at first"
            return
        }
        
        proceedLocation(location)
    }
}
