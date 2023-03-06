//
//  GetTypicodeDataUseCase.swift
//  ChatDemo
//
//  Created by cm0768 on 2023/2/22.
//

import Foundation

class GetTypicodeDataUseCase {

    private var page: Int

    init(page: Int) {
        self.page = page
    }

    private var path: String = "https://jsonplaceholder.typicode.com/albums"

    func getNetwork(completion: @escaping ((Result<[TypicodeStruct],Error>) -> Void)) {

        let urlStr = path + "/\(page)" + "/photos"

        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, respond, error in
                if let data = data {
                    do {
                        let respondItem = try JSONDecoder().decode([TypicodeStruct].self, from: data)
                        completion(.success(respondItem))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
}
