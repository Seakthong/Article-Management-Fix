//
//  ArticleServiceDelegate.swift
//  Article Management
//
//  Created by SQ on 12/26/19.
//  Copyright © 2019 SQ. All rights reserved.
//

import Foundation
import UIKit

protocol ArticleServiceDelegate {
    func responseArticle(articles : [Article]);
    func responseArticleById(article : Article);
    func responseMessage(message : String);
    func responseImageURL(urlImage : String);
}
