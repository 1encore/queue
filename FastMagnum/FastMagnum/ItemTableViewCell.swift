//
//  ItemTableViewCell.swift
//  FastMagnum
//
//  Created by Beisenbek Yerbolat on 11/14/17.
//  Copyright © 2017 Beisenbek Yerbolat. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDescr: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
