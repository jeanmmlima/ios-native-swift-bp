import SwiftUI

struct PlacesListView: View {
    @Environment(PlacesStore.self) private var store
    @State private var viewModel = PlacesListViewModel()

    @State private var showNewPlace = false

    var body: some View {
        NavigationStack {
            Group {
                if store.places.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "mappin.slash")
                            .font(.system(size: 30))
                            .foregroundStyle(.secondary)
                        Text("Nenhum local")
                            .foregroundStyle(.secondary)
                    }
                } else {
                    List(store.places) { place in
                        PlaceRow(place: place, subtitle: viewModel.formatCoordinate(latitude: place.latitude, longitude: place.longitude))
                    }
                }
            }
            .navigationTitle("Meus Lugares")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showNewPlace = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showNewPlace) {
                NewPlaceView()
            }
        }
    }
}

private struct PlaceRow: View {
    let place: Place
    let subtitle: String

    var body: some View {
        HStack(spacing: 12) {
            Group {
                if let image = ImageStorage.load(path: place.imagePath) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "photo")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 56, height: 56)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(place.title)
                    .font(.headline)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
