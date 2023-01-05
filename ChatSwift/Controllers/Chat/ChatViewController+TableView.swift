//
//  ChatViewController+TableView.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 04/01/2023.
//

import Foundation
import UIKit

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        self.registerCells()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func registerCells() {
        tableView.register(ChatMessageCell.register(), forCellReuseIdentifier: ChatMessageCell.identifier)
        tableView.register(MediaMessageCell.register(), forCellReuseIdentifier: MediaMessageCell.identifier)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let textCell = tableView.dequeueReusableCell(withIdentifier: ChatMessageCell.identifier, for: indexPath) as? ChatMessageCell,
              let imgCell = tableView.dequeueReusableCell(withIdentifier: MediaMessageCell.identifier, for: indexPath) as? MediaMessageCell else {
            return UITableViewCell()
        }
        
        let item = cellDataSources[indexPath.row]
        switch item.kind {
        case .text(_):
            dump(item)
            textCell.setupUI(with: item)
            return textCell
        case .photo(_):
            imgCell.setupUI(with: item)
            return imgCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
            if indexPath.row == lastRowIndex - 1 {
                tableView.scrollToBottom(animated: false)
            }
        }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)


        if let image = info[.editedImage] as? UIImage, let imageData =  image.pngData() {
            // Upload image
            viewModel.createImageMessage(imageData: imageData)
        }
    }
}
