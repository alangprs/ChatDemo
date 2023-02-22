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

                downloadQueue.async {
                    URLSession.shared.dataTask(with: url) { data, _, error in
                        if let data = data {

                            let image = UIImage(data: data)
                            try? data.write(to: imageFileUrl)
                            completion(.success(image))

                        } else {
                            print("will - downloadImage error")
                        }
                    }.resume()
                }
            }
        }
    }
}
