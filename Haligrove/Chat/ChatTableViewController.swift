//
//  ChatTableViewController.swift
//  Haligrove
//
//  Created by William Savary on 2018-09-14.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit

class MessageTableViewController: UITableViewController {
    
    fileprivate let cellId = "chatCell"

    fileprivate func setupTableView() {
        navigationItem.title = "Chat"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font: Font(.installed(.bakersfieldBold), size: .custom(22)).instance]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font: Font(.installed(.bakersfieldBold), size: .custom(26)).instance]
        tableView.register(ChatCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        return cell
    }

   
    
    

}
