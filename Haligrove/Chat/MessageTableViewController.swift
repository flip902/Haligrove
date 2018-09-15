//
//  ChatTableViewController.swift
//  Haligrove
//
//  Created by William Savary on 2018-09-14.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit

struct ChatMessage {
    let text: String
    let isIncoming: Bool
}

class MessageTableViewController: UITableViewController {
    
    // TODO - This will come from a database obviously
    let chatMessages = [ChatMessage(text: "Here's my first message", isIncoming: true),
                        ChatMessage(text: "This is a long message that will hopefully wordwrap, we will see?", isIncoming: true),
                        ChatMessage(text: "Here is a very long message that will word wrap, Here is a very long message that will word wrap, Here is a very long message that will word wrap, Here is a very long message that will word wrap, Here is a very long message that will word wrap, Here is a very long message that will word wrap", isIncoming: false),
                        ChatMessage(text: "yo dawg!", isIncoming: false),
                        ChatMessage(text: "This should show up on the left side of screen below the yo dawg message.", isIncoming: true)
    ]
    
    
    fileprivate let cellId = "messageCell"

    fileprivate func setupTableView() {
        navigationItem.title = "Messages"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: Font(.installed(.bakersfieldBold), size: .custom(22)).instance]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: Font(.installed(.bakersfieldBold), size: .custom(26)).instance]
        tableView.register(MessageCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessageCell
        let chatMessage = chatMessages[indexPath.row]
        cell.chatMessage = chatMessage
        return cell
    }

   
    
    

}
