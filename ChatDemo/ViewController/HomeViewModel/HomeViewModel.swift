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

    private var oldLastIndex: IndexPath?
    private var newLastIndex: IndexPath?
    private var oldLastCount = Int()

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
            oldLastCount = typicodeList.count
            GetTypicodeDataUseCase(page: page).getNetwork {[weak self] result in

                guard let self = self else { return }

                switch result {
                    case .success(let typicodeItems):
                        self.reversedTypicodeList(typicodes: typicodeItems)

                        let scrollIndex = self.getCurrentID()
                        completion(.success(scrollIndex))

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

    /// 判斷刷新資料後要滑動到的位置
    /// - Returns: 回傳要滑動到的位置
    private func getCurrentID() -> IndexPath {

        self.oldLastIndex = self.newLastIndex
        Logger.log(message: "下次要用的 index: \(String(describing: oldLastIndex))")

        // 取得新資料加入，反轉之後的最後一筆資料
        guard !typicodeList.isEmpty,
              let lastItem = typicodeList.first?.id else {
            return IndexPath()
        }

        self.newLastIndex = IndexPath(row: lastItem - oldLastCount, section: 0)

        guard let oldLastIndex = oldLastIndex else {
            oldLastIndex = newLastIndex
            Logger.log(message: "第一次刷新位置: \(String(describing: oldLastIndex))")

            return IndexPath()
        }

        return oldLastIndex

    }


    // MARK: - private func

    /// 翻轉取得資料
    private func reversedTypicodeList(typicodes: [TypicodeStruct]) {

        originaList += typicodes

        typicodeList.removeAll()
        typicodeList = originaList
        // 加入新資料後，反轉
        typicodeList.reverse()

        // 如果安排順序是依照ID，可以考慮使用以下方式處理
//        typicodeList = typicodeList.sorted { $0.id > $1.id }
    }
}
