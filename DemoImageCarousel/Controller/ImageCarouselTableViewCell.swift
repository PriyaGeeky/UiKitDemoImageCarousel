//
//  ImageCarouselTableViewCell.swift
//  DemoImageCarousel
//
//  Created by Priyanka Sahani on 01/09/24.
//

import UIKit

class ImageCarouselTableViewCell: UITableViewCell {

    @IBOutlet weak var carouselImage: UIImageView!
    
    @IBOutlet weak var carouselCornerView: UIView!
    @IBOutlet weak var carouselName: UILabel!
    
    @IBOutlet weak var carouselSecondName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        carouselCornerView.layer.cornerRadius = 12
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
