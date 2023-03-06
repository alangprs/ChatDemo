//
//  GetNetworkImageUseCase.swift
//  ChatDemo
//
//  Created by cm0768 on 2023/2/22.
//

import UIKit

class DownloadImageUseCase {

    private var path: String

    init(path: String) {
        self.path = path
    }

    func downloadImage(completion: @escaping ((Result<UIImage?, Error>) -> Void)) {

        if let url = URL(string: path) {

            let downloadQueue = DispatchQueue.global()

            let tempDirectory = FileManager.default.temporaryDirectory
            let imageFileUrl = tempDirectory.appendingPathComponent(url.lastPathComponent)

            if FileManager.default.fileExists(atPath: imageFileUrl.path) {
                let image = UIImage(contentsOfFile: imageFileUrl.path)
                completion(.success(image))
            } else {

                // into background Q
                URLSession.shared.dataTask(with: url) { data, _, error in
                    // into background Q again
                    if let data = data {

                        let image = UIImage(data: data)
                        try? data.write(to: imageFileUrl)

                        // your closure is using background Q to pass data
                        completion(.success(image))

                    } else {
                        guard let error = error else { return }
                        completion(.failure(error))
                    }
                }.resume()

            }
        }
    }
}
