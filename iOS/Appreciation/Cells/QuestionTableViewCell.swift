//
//  QuestionTableViewCell.swift
//  Appreciation
//
//  Created by Iman Zarrabian on 17/04/2019.
//  Copyright © 2019 Askia SaS. All rights reserved.
//

import UIKit

protocol QuestionTableViewCellDelegate {
    func cellDidSetNote(cell: QuestionTableViewCell, note: Double)
}
class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var noteSlider: UISlider!
    @IBOutlet weak var questionName: UILabel!
    var delegate: QuestionTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func didChangeNote(_ sender: UISlider) {
        delegate?.cellDidSetNote(cell: self, note: Double(sender.value))
    }
}
