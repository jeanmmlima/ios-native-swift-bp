import SwiftUI
import MapKit

struct MapPreviewView: UIViewRepresentable {
    let coordinate: CLLocationCoordinate2D?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.isUserInteractionEnabled = false
        mapView.showsCompass = false
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeAnnotations(mapView.annotations)

        guard let coordinate else {
            let fallback = CLLocationCoordinate2D(latitude: -3.7319, longitude: -38.5267)
            mapView.setRegion(
                MKCoordinateRegion(center: fallback, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)),
                animated: true
            )
            return
        }

        let pin = MKPointAnnotation() // Chamada nativa de anotacao no mapa
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)

        mapView.setRegion(
            MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)),
            animated: true
        )
    }
}
