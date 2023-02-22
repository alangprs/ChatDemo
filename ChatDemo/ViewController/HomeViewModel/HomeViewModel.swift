//
//  HomeViewModel.swift
//  ChatDemo
//
//  Created by cm0768 on 2023/2/22.
//

import Foundation

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
                case .success(let success):
                    self?.typicodeList = success
                    completion(.success(Void()))
                case .failure(let failure):
                    print("will - error: \(failure)")
                    completion(.failure(failure))
            }
        }
    }
}
