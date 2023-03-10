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

    /// 刷新
    private lazy var refreshControl: UIRefreshControl = {
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didReRefresh), for: .allEvents)
        return refreshControl
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
        displayTableView.addSubview(refreshControl)
    }

    private func getNetworkItem() {
        viewModel.getNetworkItem {[weak self] result in
            switch result {
                case .success(_):
                    DispatchQueue.main.async { [weak self] in
                        self?.displayTableView.reloadData()
                        self?.scrollPositionBottom()
                    }
                case .failure(let error):
                    Logger.log(message: error)
            }
        }
    }

    private func endRefreshing() {
        DispatchQueue.main.async { [weak self] in
            self?.displayTableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }

    /// 滑動到最後一個 cell
    private func scrollPositionBottom() {
        let section = displayTableView.numberOfSections
        guard section >= 1 else { return }

        let row = displayTableView.numberOfRows(inSection: section - 1)
        guard row >= 1 else { return }

        let indexPath = IndexPath(row: row - 1, section: section - 1)
        displayTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }

    private func scrollToBottom(index: IndexPath) {
        DispatchQueue.main.async {
            self.displayTableView.scrollToRow(at: index, at: .top, animated: true)
        }
    }


    @objc private func didReRefresh() {
        viewModel.configurePage()

        viewModel.getNetworkItem { result in
            switch result {
                case .success(let index):
                    self.endRefreshing()
                    self.scrollToBottom(index: index)
                case .failure(let error):
                    self.endRefreshing()
                    Logger.log(message: error)
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
            Logger.log(message: "get cell error")
            return UITableViewCell()
        }

        let typicodeItem = viewModel.configure(indexPath: indexPath)
        cell.idLabel.text = "\(typicodeItem.id)"
        cell.titleLabel.text = typicodeItem.title

        viewModel.downloadImage(imageUrl: typicodeItem.thumbnailURL) { result in
            switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        cell.iconImageView.image = image
                    }
                case .failure(let error):
                    Logger.log(message: "get cell error: \(error)")
            }
        }

        return cell
    }

}
