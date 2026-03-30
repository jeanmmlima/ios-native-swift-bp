import CoreLocation
import Observation
import UIKit

@MainActor
@Observable
final class PlacesStore {
    private(set) var places: [Place] = []

    private let repository: PlacesRepositoryProtocol

    init(repository: PlacesRepositoryProtocol = PlacesRepository()) {
        self.repository = repository
        reload()
    }

    func reload() {
        places = repository.loadPlaces()
    }

    func addPlace(title: String, image: UIImage, coordinate: CLLocationCoordinate2D?) throws {
        let place = try repository.savePlace(title: title, image: image, coordinate: coordinate)
        places.insert(place, at: 0)
    }
}
