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
                    DispatchQueue.main.async {
                        self?.displayTableView.reloadData()
                    }
                case .failure(_):
                    break
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

        var typicodeItem = viewModel.configure(indexPath: indexPath)
        cell.idLabel.text = "\(typicodeItem.id)"
        cell.titleLabel.text = typicodeItem.title

        return cell
    }


}
