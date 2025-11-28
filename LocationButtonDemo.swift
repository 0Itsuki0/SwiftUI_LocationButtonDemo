
import CoreLocation
import CoreLocationUI
import SwiftUI

struct LocationButtonDemo: View {
    @State private var coordinator = LocationCoordinator()
    @State private var locationAvailableToRequest = false
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 32) {
                VStack(spacing: 16) {
                    Text("Your Location?")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if let location = coordinator.locations.first {
                        Text("You are at (\(String(format: "%.2f", location.coordinate.longitude)), \(String(format: "%.2f", location.coordinate.latitude)))")
                    } else {
                        Text("I don't know!")
                    }
                }
                
                // Titles available:
                // - currentLocation
                // - sendCurrentLocation
                // - sendMyCurrentLocation
                // - shareCurrentLocation
                // - shareMyCurrentLocation
                LocationButton(.currentLocation, action: {
                    // Triggered when user taps the button, NOT when authorized
                    self.coordinator.pendingLocationRequest = true
                })
                
                // Modifiers To customize LocationButton appearance:
                // - labelStyle to control whether if we want the button to display an icon, a label, or both
                // - symbolVariant to set the appearance of the icon. The only one has effect is `fill`.
                // - foregroundStyle: text and icon foreground color
                // - tint: button background color
                // - font: font for icon and text
                // - buttonBorderShape: button background shape
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(.yellow.opacity(0.2))
            .navigationTitle("LocationButton Demo")
        }
    }
    
    
    @Observable
    class LocationCoordinator: NSObject, CLLocationManagerDelegate {
        var pendingLocationRequest = false {
            didSet {
                if self.pendingLocationRequest {
                    self.requestLocationIfAuthorized()
                }
            }
        }
        private(set) var locations: [CLLocation] = []
        private var locationManager = CLLocationManager()
        
        override init() {
            super.init()
            locationManager.delegate = self
        }
        
        private func requestLocationIfAuthorized() {
            print(#function)
            if (self.locationManager.authorizationStatus == .authorizedWhenInUse || self.locationManager.authorizationStatus == .authorizedWhenInUse) && self.pendingLocationRequest {
                self.locationManager.requestLocation()
                // to receive update, use the following instead
                // self.locationManager.startUpdatingLocation()
            }
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            print(#function)
            self.requestLocationIfAuthorized()
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            self.locations = locations
            self.pendingLocationRequest = false
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
            print(#function)
            print(error)
            self.pendingLocationRequest = false
        }
    }
}
