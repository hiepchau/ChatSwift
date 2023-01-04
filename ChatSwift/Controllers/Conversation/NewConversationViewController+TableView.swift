//
//  NewConversationViewController+TableView.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 04/01/2023.
//

import Foundation
import UIKit
extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //TODO: custom cell
        cell.textLabel?.text = viewModel.dataSource[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let targetUserData = viewModel.dataSource[indexPath.row]
        dismiss(animated: true, completion: { [weak self] in
            self?.completionHandler?(targetUserData.dictionary)
        })

    }
    
    //TODO: search handle
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){

    }
}
