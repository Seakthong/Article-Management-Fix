//
//  TableViewController.swift
//  Article Management
//
//  Created by SQ on 12/25/19.
//  Copyright © 2019 SQ. All rights reserved.
//

import UIKit
import SCLAlertView

class TableViewController: UITableViewController {
    
    // MARK: - Limit data when show or get from API
    private var limit : Int = 10
    private var scrollIndex = 1;
    let articleViewModel = ArticleViewModel()
    var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "tableCell")
        articleViewModel.articleViewModelDelegate = self
        articleViewModel.getArticles(page: 1, limit: limit)
        
        // MARK: - Fetch New Data from API
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(fetchArticle), for: .valueChanged)
        refresh.tintColor = .white
        tableView.refreshControl = refresh
    }

    
    @objc func fetchArticle(_ refresh : UIRefreshControl){
        articleViewModel.getArticles(page: 1, limit: limit)
        refresh.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        articleViewModel.getArticles(page: 1, limit: limit)
        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableViewCell
        
        // Set Data to Each Cell
        cell.setArticle(article: articles[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewArticleViewController = storyBoard.instantiateViewController(withIdentifier: "viewArticleViewController") as! ViewArticleViewController
        viewArticleViewController.article = articles[indexPath.row]
        self.navigationController?.pushViewController(viewArticleViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        96
    }
    
    // MARK: - When Leading Swape to Edit
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title:  "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewArticleViewController = storyBoard.instantiateViewController(withIdentifier: "editArticleViewController") as! EditArticleViewController
                    viewArticleViewController.article = self.articles[indexPath.row]
                    self.navigationController?.pushViewController(viewArticleViewController, animated: true)
                    success(true)
                })
        editAction.image = UIImage(systemName: "pencil")
        editAction.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [editAction])
        
    }
    
    // MARK: - When Trailing Swape to Delete
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    success(true)
                    self.articleViewModel.deleteArticle(id: self.articles[indexPath.row].id!)
                    self.articles.remove(at: indexPath.row)
                    self.tableView.reloadData()
                })
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let curOffset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (maxOffset - curOffset) <= 10{
            self.fetchMore();
        }
    }
    
    func fetchMore(){
        print("MORE MORE")
        articleViewModel.getArticles(page: 1, limit: scrollIndex*limit)
        scrollIndex += 1
    }
}

extension TableViewController : ArticleViewModelDelegate{
    func responseArticle(articles: [Article]) {
        self.articles = articles
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func responseArticleById(article: Article) { }
    
    func responseMessage(message: String) {
        DispatchQueue.main.async {
            SCLAlertView().showSuccess("CONGRATULATIONS", subTitle: message.lowercased())
        }
    }
    
    func responseImageURL(urlImage : String){
        
    }
}


