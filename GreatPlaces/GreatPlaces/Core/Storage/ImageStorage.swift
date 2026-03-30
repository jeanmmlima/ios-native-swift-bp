import Foundation
import UIKit

enum ImageStorage {
    static func save(_ image: UIImage) throws -> String {
        guard let data = image.jpegData(compressionQuality: 0.85) else {
            throw NSError(domain: "ImageStorage", code: 1, userInfo: [NSLocalizedDescriptionKey: "Nao foi possivel salvar a imagem"]) 
        }

        let fileName = "IMG_\(UUID().uuidString).jpg"
        let url = documentsDirectory().appendingPathComponent(fileName)
        try data.write(to: url, options: .atomic)
        return url.path
    }

    static func load(path: String) -> UIImage? {
        UIImage(contentsOfFile: path)
    }

    private static func documentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
