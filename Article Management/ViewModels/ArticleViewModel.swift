//
//  ArticleViewModel.swift
//  Article Management
//
//  Created by SQ on 12/26/19.
//  Copyright © 2019 SQ. All rights reserved.
//

import Foundation
import UIKit

class ArticleViewModel : ArticleServiceDelegate{
    var articleViewModelDelegate : ArticleViewModelDelegate?
    var articleService : ArticleService?
    
    init() {
        articleService = ArticleService()
        articleService?.delegate = self
    }
    
    func getArticles(page : Int, limit : Int){
        articleService?.getArticles(page: page, limit: limit)
    }
    
    func getArticleById(id : Int){
        articleService?.getArticleById(id: id)
    }
    
    func addArticle(article : Article){
        articleService?.addArticle(article: article)
    }
    
    func uploadImage(image : UIImage) {
        articleService?.uploadImage(image: image)
    }
    
    func deleteArticle(id : Int){
        articleService?.deleteArticle(id: id)
    }
    
    func editArticle(article : Article){
        articleService?.editArticle(article: article)
    }
    
    func responseArticle(articles: [Article]) {
        articleViewModelDelegate?.responseArticle(articles: articles)
    }
    
    func responseArticleById(article: Article) {
        articleViewModelDelegate?.responseArticleById(article: article)
    }
    
    func responseMessage(message: String) {
        articleViewModelDelegate?.responseMessage(message: message)
    }
    
    func responseImageURL(urlImage : String){
        articleViewModelDelegate?.responseImageURL(urlImage: urlImage)
    }
    
}
