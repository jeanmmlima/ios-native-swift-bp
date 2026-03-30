import Foundation
import Observation

@MainActor
@Observable
final class PlacesListViewModel {
    func formatCoordinate(latitude: Double?, longitude: Double?) -> String {
        guard let latitude, let longitude else {
            return "Localizacao nao informada"
        }

        return String(format: "%.5f, %.5f", latitude, longitude)
    }
}
