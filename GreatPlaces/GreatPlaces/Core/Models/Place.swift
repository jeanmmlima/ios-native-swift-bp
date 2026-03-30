import Foundation

struct Place: Identifiable, Equatable {
    let id: String
    let title: String
    let imagePath: String
    let latitude: Double?
    let longitude: Double?

    init(
        id: String = UUID().uuidString,
        title: String,
        imagePath: String,
        latitude: Double? = nil,
        longitude: Double? = nil
    ) {
        self.id = id
        self.title = title
        self.imagePath = imagePath
        self.latitude = latitude
        self.longitude = longitude
    }
}
