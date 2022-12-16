//
//  CarCell.swift
//  Cars
//
//  Created by Linkon Sid on 12/12/22.
//

import UIKit

class CarCell: UITableViewCell,ReusableCell {
    
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var header: UILabel!
    static var nib: UINib? {
        return UINib(nibName: String(describing: CarCell.self), bundle: nil)
    }
    public var data : ViewData! {
        didSet {
            if let imageData = data.image?.replacingOccurrences(of: ".jpg", with: ""){
                
                self.banner.image = UIImage(named: imageData)
            }
            self.header.text = data.title
            self.dateTime.text = data.date
            self.desc.text = data.description
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//    }
}
