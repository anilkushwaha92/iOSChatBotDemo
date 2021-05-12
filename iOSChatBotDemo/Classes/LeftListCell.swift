//
//  LeftListCell.swift
//  ChatBotTest
//
//  Created by Anil Kushwaha on 03/05/21.
//

import UIKit

class LeftListCell: UITableViewCell {

    @IBOutlet weak var messageLbl: PaddingLabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageLbl.padding(10, 10, 10, 10)
        messageLbl.layer.masksToBounds = true
        messageLbl.layer.cornerRadius = 5.0
        imgView.layer.cornerRadius = 20.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
