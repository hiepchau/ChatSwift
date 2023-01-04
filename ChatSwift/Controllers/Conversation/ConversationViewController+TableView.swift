//
//  ConversationViewController+TableView.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 03/01/2023.
//

import Foundation
import UIKit

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.registerCells()
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func registerCells() {
        tableView.register(ConversationTableViewCell.register(), forCellReuseIdentifier: ConversationTableViewCell.identifier)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier, for: indexPath) as? ConversationTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: cellDataSources[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = ChatViewController()
//        vc.currentConversationID = cellDataSources[indexPath.row].id
//        vc.title = cellDataSources[indexPath.row].username
//        vc.navigationItem.largeTitleDisplayMode = .never
//        navigationController?.pushViewController(vc, animated: true)
    }
}
