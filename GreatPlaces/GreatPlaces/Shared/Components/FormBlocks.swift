import SwiftUI
import CoreLocation

struct ImageInputBlock: View {
    @Binding var image: UIImage?
    let onTakePhoto: () -> Void
    let onPickFromLibrary: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.secondary.opacity(0.4), lineWidth: 1)
                        .frame(width: 180, height: 100)

                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 180, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        Text("Nenhuma imagem")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }

                Button(action: onTakePhoto) {
                    Label("Tirar foto", systemImage: "camera")
                }
                .buttonStyle(.bordered)
            }

            Button(action: onPickFromLibrary) {
                Label("Escolher da biblioteca", systemImage: "photo")
            }
            .buttonStyle(.bordered)
        }
    }
}

struct LocationInputBlock: View {
    let coordinate: CLLocationCoordinate2D?
    let isLoading: Bool
    let onCurrentLocation: () -> Void
    let onSelectOnMap: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.secondary.opacity(0.4), lineWidth: 1)
                    .frame(height: 170)

                if let coordinate {
                    MapPreviewView(coordinate: coordinate)
                        .frame(height: 170)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    Text("Localizacao nao informada")
                        .foregroundStyle(.secondary)
                }

                if isLoading {
                    ProgressView()
                        .padding(8)
                        .background(.ultraThinMaterial, in: Capsule())
                }
            }

            HStack {
                Button(action: onCurrentLocation) {
                    Label("Localizacao atual", systemImage: "location")
                }
                .buttonStyle(.bordered)

                Spacer()

                Button(action: onSelectOnMap) {
                    Label("Selecionar no mapa", systemImage: "map")
                }
                .buttonStyle(.bordered)
            }
        }
    }
}
