//
//  ButtonTableViewCell.swift
//  ShoppingList2
//
//  Created by Kevin Hartley on 5/27/16.
//  Copyright © 2016 BigNerdRanch. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
    
    weak var delegate: ShoppingListTableViewCellDelegate?
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    //MARK: - IBActions
    
    @IBAction func buttonTapped(sender: AnyObject) {
        delegate?.buttonCellButtonTapped(self)
    }
    
    func updateWithShoppingList(shoppingList: ShoppingList) {
        primaryLabel.text = shoppingList.title
        shoppingListValueChanged((shoppingList.completed?.boolValue)!)
    }
    
    func shoppingListValueChanged(value: Bool) {
        if value == true {
            button.imageView?.image = UIImage(named: "circleFilled")
        } else {
            button.imageView?.image = UIImage(named: "circleEmpty")
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

protocol ShoppingListTableViewCellDelegate: class {
    func buttonCellButtonTapped(cell: ButtonTableViewCell)
}
