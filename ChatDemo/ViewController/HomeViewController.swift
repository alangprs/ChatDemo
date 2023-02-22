//
//  HomeViewController.swift
//  ChatDemo
//
//  Created by cm0768 on 2023/2/22.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {

    private lazy var viewModel: HomeViewModel = {
        var vm = HomeViewModel()
        return vm
    }()

    private lazy var displayTableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    // MARK: - 生命週期

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getNetworkItem()
    }

    // MARK: - func

    private func setupUI() {
        view.backgroundColor = .systemRed

        view.addSubview(displayTableView)
        displayTableView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        displayTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "\(HomeTableViewCell.self)")
    }

    private func getNetworkItem() {
        viewModel.getNetworkItem {[weak self] result in
            switch result {
                case .success(_):
                    DispatchQueue.main.async { [weak self] in
                        self?.displayTableView.reloadData()
                    }
                case .failure(let error):
                    print("will - error: \(error)")
            }
        }
    }
}

// MARK: - tableViewDelegate

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.typicodeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = displayTableView.dequeueReusableCell(withIdentifier: "\(HomeTableViewCell.self)", for: indexPath) as? HomeTableViewCell else {
            print("will - get cell error")
            return UITableViewCell()
        }

        let typicodeItem = viewModel.configure(indexPath: indexPath)
        cell.idLabel.text = "\(typicodeItem.id)"
        cell.titleLabel.text = typicodeItem.title

        viewModel.downloadImage(imageUrl: typicodeItem.thumbnailURL) { result in
            switch result {
                case .success(let image):
                    DispatchQueue.main.async { [weak self] in
                        cell.iconImageView.image = image

                        self?.displayTableView.reloadRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .none)
                    }
                case .failure(let error):
                    print("will - downloadImage error: \(error)")
            }
        }

        return cell
    }


}
