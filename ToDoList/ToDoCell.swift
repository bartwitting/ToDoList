//
//  ToDoCell.swift
//  ToDoList
//
//  Created by Bart Witting on 28/11/2018.
//  Copyright © 2018 Bart Witting. All rights reserved.
//

import UIKit

@objc protocol ToDoCellDelegate: class {
    func checkmarkTapped(sender: ToDoCell)
}

class ToDoCell: UITableViewCell {
    var delegate: ToDoCellDelegate?

    @IBOutlet weak var isCompleteButt: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func isCompletePressed(_ sender: UIButton) {
        delegate?.checkmarkTapped(sender: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
