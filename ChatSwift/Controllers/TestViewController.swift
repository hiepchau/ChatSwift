//
//  TestViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 19/12/2022.
//

import UIKit

class TestViewController: UIViewController {

    
    let msg = ["ASD",
               "ASDASDASDASDASD",
               "ASDASDASDASDASDASDASDADASDASD",
               "ASDASDASDASDASDASDASDADASDASDASDASDASDASDASDASDASDADASDASDASDASDASDASDASDASDASDADASDASD",
               "ASDASDASDASDASDASDASDADASDASDASDASDASDASDASDASDASDADASDASDASDASDASDASDASDASDASDADASDASDASDASDASDASDASDASDASDADASDASDASDASDASDASDASDASDASDADASDASDASDASDASDASDASDASDASDADASDASD"]
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
     
    }
    
    
}

extension TestViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msg.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "msgCell", for: indexPath) as! ChatMessageCell
    
        cell.leadingLabel.priority = UILayoutPriority(999)
        cell.msglabel.text = msg[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
