//
//  TableViewCell.swift
//  Article Management
//
//  Created by SQ on 12/25/19.
//  Copyright © 2019 SQ. All rights reserved.
//

import UIKit
import Kingfisher

class TableViewCell: UITableViewCell {

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleViewCountLabel: UILabel!
    @IBOutlet weak var articleDateLabel: UILabel!
    @IBOutlet weak var articleAuthorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        articleImageView.layer.borderColor = UIColor.blue.cgColor
        articleImageView.layer.borderWidth = 1.0
        // Configure the view for the selected state
    }
    
    func setArticle(article : Article){
        if article.image == ""{
            print("NO IMAGE")
            self.articleImageView.image = UIImage()
        }
        else if let image = article.image {
            print("IMAGE")
            let url = URL(string: image)
            self.articleImageView.kf.setImage(with: url)
        }
        self.articleTitleLabel.text = (article.title == "" ? "NO TITLE" : article.title)
        self.articleViewCountLabel.text = "VIEW COUNT : \(article.viewCount!)"
        self.articleDateLabel.text = "DATE : \(article.date!)"
        self.articleAuthorLabel.text = "AUTHOR : \(article.author!)"
    }
    
}

