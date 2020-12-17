//
//  Article.swift
//  Article Management
//
//  Created by SQ on 12/26/19.
//  Copyright © 2019 SQ. All rights reserved.
//

import Foundation
import SwiftyJSON

class Article{
    var id : Int?
    var title : String?
    var description : String?
    var image : String?
    var viewCount : Int?
    var author : String?
    var date : String?
    init(){ }
    init(json : JSON){
        self.id = json["id"].int
        self.title = json["title"].string
        self.description = json["description"].string
        self.image = json["image_url"].string
        self.date = Date.getFormattedDate(string: "\(json["created_date"].string!)")
    }
    
}


extension Date {
    // MARK: - Format Date to show on View
    static func getFormattedDate(string: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyyMMddHHmmss"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"

        let date: Date? = dateFormatterGet.date(from: string)
        return dateFormatterPrint.string(from: date!);
    }
}
