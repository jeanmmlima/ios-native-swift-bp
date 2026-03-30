import SwiftUI
import MapKit

struct MapSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCoordinate: CLLocationCoordinate2D?

    var body: some View {
        NavigationStack {
            TappableMapRepresentable(selectedCoordinate: $selectedCoordinate)
                .ignoresSafeArea(edges: .bottom)
                .navigationTitle("Selecione no Mapa")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Concluir") { dismiss() }
                    }
                }
        }
    }
}

private struct TappableMapRepresentable: UIViewRepresentable {
    @Binding var selectedCoordinate: CLLocationCoordinate2D?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true // Chamada nativa para mostrar usuario no mapa

        let start = selectedCoordinate ?? CLLocationCoordinate2D(latitude: -3.7319, longitude: -38.5267)
        mapView.setRegion(
            MKCoordinateRegion(center: start, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)),
            animated: false
        )

        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        mapView.addGestureRecognizer(tap)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        context.coordinator.renderPin(on: uiView, coordinate: selectedCoordinate)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(selectedCoordinate: $selectedCoordinate)
    }

    final class Coordinator: NSObject, MKMapViewDelegate {
        @Binding private var selectedCoordinate: CLLocationCoordinate2D?

        init(selectedCoordinate: Binding<CLLocationCoordinate2D?>) {
            self._selectedCoordinate = selectedCoordinate
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let mapView = gesture.view as? MKMapView else { return }
            let point = gesture.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            selectedCoordinate = coordinate
            renderPin(on: mapView, coordinate: coordinate)
        }

        func renderPin(on mapView: MKMapView, coordinate: CLLocationCoordinate2D?) {
            mapView.removeAnnotations(mapView.annotations.filter { !($0 is MKUserLocation) })
            guard let coordinate else { return }

            let pin = MKPointAnnotation()
            pin.coordinate = coordinate
            mapView.addAnnotation(pin)
        }
    }
}
