//
//  NewConversationViewController+TableView.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 04/01/2023.
//
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
        cell.textLabel?.text = cellDataSources[indexPath.row].name
        print(cellDataSources[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let targetUserData = viewModel.retriveUser(withId: cellDataSources[indexPath.row].id) else { return }
        dismiss(animated: true, completion: { [weak self] in
            self?.completionHandler?(targetUserData.dictionary)
        })

    }
    
    //TODO: search handle
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
    }
}
