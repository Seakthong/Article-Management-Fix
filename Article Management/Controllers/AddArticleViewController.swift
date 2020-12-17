//
//  AddArticleViewController.swift
//  Article Management
//
//  Created by SQ on 12/26/19.
//  Copyright © 2019 SQ. All rights reserved.
//

import UIKit
import SCLAlertView

class AddArticleViewController: UIViewController {
    
    @IBOutlet weak var articleTitleTextField: UITextField!
    @IBOutlet weak var articleDescriptionTextView: UITextView!
    @IBOutlet weak var articleImageView: UIImageView!
    
    @IBOutlet weak var articleAddButton: UIButton!
    @IBOutlet weak var addButtonTrailingCont: NSLayoutConstraint!
    @IBOutlet weak var addButtonBottomCont: NSLayoutConstraint!
    
    var articleViewModel : ArticleViewModel?
    var imagePicker : UIImagePickerController?
    var imageURL : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleViewModel = ArticleViewModel()
        articleViewModel?.articleViewModelDelegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.allowsEditing = false
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(pickImage(_:)))
            
        articleImageView.isUserInteractionEnabled = true
        articleImageView.isMultipleTouchEnabled = true
        articleImageView.addGestureRecognizer(tabGesture)
        
        self.articleTitleTextField.delegate = self
        
        customizeView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.articleAddButton.alpha = 0
        addButtonTrailingCont.constant -= 70
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .allowUserInteraction, animations: {
            self.addButtonTrailingCont.constant += 70
            self.articleAddButton.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    func customizeView(){
        articleImageView.layer.borderWidth = 1.0
        articleImageView.layer.borderColor = UIColor.blue.cgColor
        articleAddButton.layer.cornerRadius = 0.5
        articleAddButton.layer.cornerRadius = 0.5 * articleAddButton.bounds.size.width
    }
    
    @objc func pickImage(_ sender : Any){
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        // Open Photo Library
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (actioln) in
            self.imagePicker?.sourceType = .photoLibrary
            self.present(self.imagePicker!, animated: true, completion: nil)
            
        }))
        
        // Open Camera
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (actioln) in
            self.imagePicker?.sourceType = .camera
            self.present(self.imagePicker!, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true) {
            
        }
    }

    @IBAction func addArticleTouched(_ sender: UIButton) {
        articleViewModel?.uploadImage(image: articleImageView.image!)
    }
    
}

extension AddArticleViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

extension AddArticleViewController : ArticleViewModelDelegate {
    func responseArticle(articles: [Article]) { }

    func responseArticleById(article: Article) { }

    func responseMessage(message: String) {
        DispatchQueue.main.async {
            SCLAlertView().showSuccess("CONGRATULATIONS", subTitle: message.lowercased())
        }
    }
    
    func responseImageURL(urlImage : String){
        self.imageURL = urlImage
        let article = Article()
        article.title = articleTitleTextField.text
        article.description = articleDescriptionTextView.text
        article.image = imageURL
        imageURL = nil
        articleViewModel?.addArticle(article: article)
    }
}

extension AddArticleViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image : UIImage = info[.originalImage] as? UIImage{
            self.articleImageView.image = image
        }
        self.imagePicker?.dismiss(animated: true, completion: nil)
    }
    
    
}
