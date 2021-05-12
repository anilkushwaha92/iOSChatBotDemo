//
//  RightListCell.swift
//  ChatBotTest
//
//  Created by Anil Kushwaha on 03/05/21.
//

import UIKit

class RightListCell: UITableViewCell {

    @IBOutlet weak var messageLbl: PaddingLabel!
    @IBOutlet weak var rightImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageLbl.padding(10, 10, 10, 10)
        messageLbl.layer.masksToBounds = true
        messageLbl.layer.cornerRadius = 5.0
        rightImg.layer.cornerRadius = 20.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
