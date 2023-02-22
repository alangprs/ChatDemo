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

    func getNetworkItem() {
        getTypicodeDataUseCase.getNetwork { result in

            switch result {
                case .success(let success):
                    print("will - data: \(success)")
                case .failure(let failure):
                    print("will - error: \(failure)")
            }
        }
    }
}
