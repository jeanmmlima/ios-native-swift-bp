import SwiftUI
import UIKit

struct NewPlaceView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(PlacesStore.self) private var store
    @State private var viewModel = NewPlaceViewModel()

    @State private var showCamera = false
    @State private var showLibrary = false
    @State private var showMapSelection = false
    @State private var showCameraUnavailableAlert = false

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack {
            Form {
                Section("Dados") {
                    TextField("Titulo", text: $viewModel.title)
                }

                Section("Imagem") {
                    ImageInputBlock(
                        image: $viewModel.selectedImage,
                        onTakePhoto: {
                            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                showCamera = true
                            } else {
                                showCameraUnavailableAlert = true
                            }
                        },
                        onPickFromLibrary: { showLibrary = true }
                    )
                }

                Section("Localizacao") {
                    LocationInputBlock(
                        coordinate: viewModel.selectedCoordinate,
                        isLoading: viewModel.isLoadingLocation,
                        onCurrentLocation: { viewModel.fetchCurrentLocation() },
                        onSelectOnMap: { showMapSelection = true }
                    )
                }
            }
            .navigationTitle("Novo Lugar")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Adicionar") {
                        do {
                            try viewModel.save(into: store)
                            dismiss()
                        } catch {
                            viewModel.errorMessage = error.localizedDescription
                        }
                    }
                    .disabled(!viewModel.canSave)
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraPickerView(sourceType: .camera) { image in
                    viewModel.selectedImage = image
                }
            }
            .sheet(isPresented: $showLibrary) {
                CameraPickerView(sourceType: .photoLibrary) { image in
                    viewModel.selectedImage = image
                }
            }
            .sheet(isPresented: $showMapSelection) {
                MapSelectionView(selectedCoordinate: $viewModel.selectedCoordinate)
            }
            .alert("Camera indisponivel", isPresented: $showCameraUnavailableAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Use um dispositivo fisico ou escolha da biblioteca.")
            }
            .alert("Erro", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { isPresented in
                    if !isPresented { viewModel.errorMessage = nil }
                }
            )) {
                Button("OK", role: .cancel) {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "Erro desconhecido")
            }
        }
    }
}
