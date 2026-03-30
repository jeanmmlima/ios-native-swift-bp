import Foundation
import CoreLocation
import Observation
import UIKit

@MainActor
@Observable
final class NewPlaceViewModel: NSObject {
    var title: String = ""
    var selectedImage: UIImage?
    var selectedCoordinate: CLLocationCoordinate2D?
    var isLoadingLocation = false
    var errorMessage: String?

    private let locationManager = CLLocationManager()
    private var locationCompletion: ((Result<CLLocationCoordinate2D, Error>) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }

    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && selectedImage != nil
    }

    func fetchCurrentLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            errorMessage = "Servicos de localizacao desativados."
            return
        }

        switch locationManager.authorizationStatus {
        case .notDetermined:
            isLoadingLocation = true
            locationManager.requestWhenInUseAuthorization() // Chamada nativa de permissao de localizacao
        case .authorizedWhenInUse, .authorizedAlways:
            requestSingleLocation()
        case .restricted, .denied:
            errorMessage = "Permissao de localizacao negada."
        @unknown default:
            errorMessage = "Falha ao obter localizacao."
        }
    }

    func save(into store: PlacesStore) throws {
        guard let selectedImage else { return }

        try store.addPlace(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            image: selectedImage,
            coordinate: selectedCoordinate
        )
    }

    private func requestSingleLocation() {
        isLoadingLocation = true
        locationCompletion = { [weak self] result in
            guard let self else { return }
            self.isLoadingLocation = false

            switch result {
            case .success(let coordinate):
                self.selectedCoordinate = coordinate
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }

        locationManager.requestLocation() // Chamada nativa de leitura da localizacao atual
    }
}

extension NewPlaceViewModel: CLLocationManagerDelegate {
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor [weak self] in
            guard let self else { return }

            let status = manager.authorizationStatus
            if status == .authorizedAlways || status == .authorizedWhenInUse {
                self.requestSingleLocation()
            } else if status == .denied || status == .restricted {
                self.isLoadingLocation = false
                self.errorMessage = "Permissao de localizacao negada."
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            locationManager(manager, didFailWithError: NSError(domain: "Location", code: 1, userInfo: [NSLocalizedDescriptionKey: "Localizacao indisponivel"]))
            return
        }

        Task { @MainActor [weak self] in
            self?.locationCompletion?(.success(location.coordinate))
            self?.locationCompletion = nil
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor [weak self] in
            self?.locationCompletion?(.failure(error))
            self?.locationCompletion = nil
        }
    }
}
