import CoreLocation
import UIKit

protocol PlacesRepositoryProtocol {
    func loadPlaces() -> [Place]
    func savePlace(title: String, image: UIImage, coordinate: CLLocationCoordinate2D?) throws -> Place
}

final class PlacesRepository: PlacesRepositoryProtocol {
    func loadPlaces() -> [Place] {
        PlacesDatabase.shared.fetchAll()
    }

    func savePlace(title: String, image: UIImage, coordinate: CLLocationCoordinate2D?) throws -> Place {
        let imagePath = try ImageStorage.save(image)
        let place = Place(
            title: title,
            imagePath: imagePath,
            latitude: coordinate?.latitude,
            longitude: coordinate?.longitude
        )

        PlacesDatabase.shared.insert(place)
        return place
    }
}
