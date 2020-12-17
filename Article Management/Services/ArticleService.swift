//
//  ArticleService.swift
//  Article Management
//
//  Created by SQ on 12/26/19.
//  Copyright © 2019 SQ. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ArticleService{
    
    let ARTICLE_URL = "http://110.74.194.124:15011/v1/api/articles"
    var delegate : ArticleServiceDelegate?
    var path : String?
    let HEADER = [
        "Accept":"application/json",
        "Content-Type":"application/json",
        "Authorization":"Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ="
        
    ]
    
    var authors = ["Dr. MP, PhD","Dr. SQ, PhD","Mr. Sok","Mr. Hang","Mr. Kok","Mr. Sa"]

    func getArticles(page : Int, limit : Int){
        let url = "\(ARTICLE_URL)?page=\(page)&limit=\(limit)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.isSuccess{
                let json = try? JSON(data: response.data!)
                let articlesJsonArray = json!["data"].array
                var articles = [Article]()
                for articleJson in articlesJsonArray!{
                    let article = Article.init(json: articleJson)
                    article.author = self.authors.randomElement()
                    article.viewCount = Int.random(in: 0...1000)
                    articles.append(article)
                }
                self.delegate?.responseArticle(articles: articles)
            }
        }
    }
    
    func getArticleById(id : Int){
        let url = "\(ARTICLE_URL)/\(id)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            let json = try? JSON(data: response.data!)
            let articleJson = json!["data"]
            let article = Article(json: articleJson)
            self.delegate?.responseArticleById(article : article)
        }
    }
    
    func addArticle(article : Article){
        let url = "\(ARTICLE_URL)"
        let params : [String : Any] = [
            "title": article.title!,
            "description": article.description!,
            "author": 0,
            "status": "string",
            "image": article.image!
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            let json = try? JSON(data: response.data!)
            let message = json?["message"].string
            self.delegate?.responseMessage(message: message!)
        }
        
    }
    
    func uploadImage(image : UIImage) {
        let UPLOAD_URL = "http://110.74.194.124:15011/v1/api/uploadfile/single"
        guard let imageData = image.jpegData(compressionQuality: 0.50) else { return }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData, withName: "file", fileName: "image.jpg", mimeType: "image/jpg")
        }, to: UPLOAD_URL, headers: HEADER) { (result) in
            print(result)
            switch result {
            case .success(let upload, _, _):
                print(upload)
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                print(upload)
                upload.responseJSON { response in
                    print(response, "IN RES")
                    if let dic : [String : Any] = response.result.value as? [String : Any] {
                        dic.forEach { (key, value) in
                            print(key, value)
                        }
                        if(dic["code"] as! Int == 2222) {
                            self.delegate?.responseImageURL(urlImage: dic["data"] as! String)
                        } else {
                            self.delegate?.responseImageURL(urlImage: "")
                        }
                    }
                }
                print(upload)
            case .failure(let encodingError):
                print("Error : ", encodingError)
            }
        }
    }
    
    func deleteArticle(id : Int){
        let url = "\(ARTICLE_URL)/\(id)"
        Alamofire.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            let json = try? JSON(data: response.data!)
            let message = json?["message"].string
            self.delegate?.responseMessage(message: message!)
        }
    }
    
    func editArticle(article : Article){
        let url = "\(ARTICLE_URL)/\(String(describing: article.id!))"
        let params : [String : Any] = [
            "title": article.title!,
            "description": article.description!,
              "author": 0,
              "category_id": 1,
              "status": "string",
              "image": article.image!
        ]
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            let json = try? JSON(data: response.data!)
            let message = json?["message"].string
            self.delegate?.responseMessage(message: message!)
        }
    }
}
