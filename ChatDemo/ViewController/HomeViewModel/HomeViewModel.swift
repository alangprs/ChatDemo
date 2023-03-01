//
//  HomeViewModel.swift
//  ChatDemo
//
//  Created by cm0768 on 2023/2/22.
//

import UIKit

class HomeViewModel {

    /// 未反轉資料
    private var originaList: [TypicodeStruct] = []

    /// 顯示用已反轉資料
    private(set) var typicodeList: [TypicodeStruct] = []

    private var page: Int = 1

    /// true = 抓資料中
    private(set) lazy var isReFresh: Bool = {
        return false
    }()

    private var lastIndex = IndexPath()

    // MARK: - public func

    func configure(indexPath: IndexPath) -> TypicodeStruct {
        return typicodeList[indexPath.row]
    }

    func configurePage() {

        if !isReFresh {
            page += 1
        }
    }

    func getNetworkItem(completion: @escaping ((Result<IndexPath, Error>) -> Void)) {

        if !isReFresh {
            isReFresh = true
            GetTypicodeDataUseCase(page: page).getNetwork {[weak self] result in

                guard let self = self else { return }

                switch result {
                    case .success(let typicodeItems):
                        self.reversedTypicodeList(typicodes: typicodeItems)
                        completion(.success(self.lastIndex))
                        self.getCurrentID()
                    case .failure(let failure):
                        completion(.failure(failure))
                }
                
                self.isReFresh = false
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

    /// 取得最後一個 ID
    private func getCurrentID() {

        guard !typicodeList.isEmpty,
              let lastID = typicodeList.first?.id else {
            Logger.errorLog(message: "vm lastIndex error")
            return
        }

        if let lastIndexID = typicodeList.first(where: {$0.id == lastID}) {

            lastIndex = IndexPath(row: lastIndexID.id, section: 0)
            Logger.log(message: "vm \(lastIndex)")
        }

    }


    // MARK: - private func

    /// 翻轉取得資料
    private func reversedTypicodeList(typicodes: [TypicodeStruct]) {
        // TODO: - 如果有換頁，記得清空 array

        originaList += typicodes

        typicodeList.removeAll()
        typicodeList = originaList
        // 加入新資料後，反轉
        typicodeList.reverse()
    }
}
