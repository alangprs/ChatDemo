//
//  HomeViewModel.swift
//  ChatDemo
//
//  Created by cm0768 on 2023/2/22.
//

import UIKit

class HomeViewModel {

    private lazy var getTypicodeDataUseCase: GetTypicodeDataUseCase = {
        return GetTypicodeDataUseCase()
    }()

    private(set) var typicodeList: [TypicodeStruct] = []

    func configure(indexPath: IndexPath) -> TypicodeStruct {
        return typicodeList[indexPath.row]
    }

    func getNetworkItem(completion: @escaping ((Result<Void, Error>) -> Void)) {
        getTypicodeDataUseCase.getNetwork {[weak self] result in

            switch result {
                case .success(let typicodeItems):
                    self?.reversedTypicodeList(typicodes: typicodeItems)
                    completion(.success(Void()))
                case .failure(let failure):
                    completion(.failure(failure))
            }
        }
    }

    func downloadImage(imageUrl path: String, completion: @escaping ((Result<UIImage, Error>) -> Void)) {
        let downloadImageUseCase = DownloadImageUseCase(path: path)

        downloadImageUseCase.downloadImage { result in
            switch result {
                case .success(let success):
                    guard let imageItem = success else { return }
                    completion(.success(imageItem))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }

    /// 翻轉取得資料
    private func reversedTypicodeList(typicodes: [TypicodeStruct]) {
        // TODO: - 如果有換頁，記得清空 array
        
        typicodeList += typicodes.reversed()
    }
}
