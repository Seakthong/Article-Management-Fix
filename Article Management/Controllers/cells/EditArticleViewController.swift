//
//  EditArticleViewController.swift
//  Article Management
//
//  Created by SQ on 12/27/19.
//  Copyright © 2019 SQ. All rights reserved.
//

import UIKit
import SCLAlertView

class EditArticleViewController: UIViewController {
    
    @IBOutlet weak var articleTitleTextField: UITextField!
    @IBOutlet weak var articleDescriptionTextView: UITextView!
    @IBOutlet weak var articleImageView: UIImageView!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var editButtonTrailingCont: NSLayoutConstraint!
    
    var articleViewModel = ArticleViewModel();
    var article : Article?
    var imagePicker : UIImagePickerController?
    var imageURL : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleViewModel = ArticleViewModel()
        articleViewModel.articleViewModelDelegate = self
        
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
        
        // MARK: - Set Article to Show on View
        articleTitleTextField.text = article?.title
        articleDescriptionTextView.text = article?.description
        
        // Check Condition if image is ""
        self.articleImageView.image = UIImage(named: "no-image")
        if article!.image == ""{
            self.articleImageView.image = UIImage(named: "no-image")
        }
        else if let image = article!.image{
            let url = URL(string: image)
            self.articleImageView.kf.setImage(with: url)
        }
        // Make Button Edit to curX to x - 70
        self.editButtonTrailingCont.constant -= 70;
        self.editButton.alpha = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            // Make Button Edit to curX
            self.editButtonTrailingCont.constant += 70
            self.editButton.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    func customizeView(){
        articleImageView.layer.borderWidth = 1.0
        articleImageView.layer.borderColor = UIColor.blue.cgColor
        editButton.layer.cornerRadius = 0.5
        editButton.layer.cornerRadius = 0.5 * editButton.bounds.size.width
    }
    
    @objc func pickImage(_ sender : Any){
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (actioln) in
            self.imagePicker?.sourceType = .photoLibrary
            self.present(self.imagePicker!, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (actioln) in
            self.imagePicker?.sourceType = .camera
            self.present(self.imagePicker!, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true) {
            
        }
    }
    
    @IBAction func editTouched(_ sender: Any) {
        self.articleViewModel.uploadImage(image: self.articleImageView.image ?? UIImage(named: "no-image")!)
    }
}

extension EditArticleViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

extension EditArticleViewController : ArticleViewModelDelegate{
    func responseArticle(articles: [Article]) { }
    
    func responseArticleById(article: Article) { }
    
    func responseMessage(message: String) {
        DispatchQueue.main.async {
            SCLAlertView().showEdit("CONGRATULATIONS", subTitle: message.lowercased())
        }
    }
    
    func responseImageURL(urlImage: String) {
        self.imageURL = urlImage
        article?.title = articleTitleTextField.text
        article?.description = articleDescriptionTextView.text
        article?.image = imageURL
        imageURL = nil
        articleViewModel.editArticle(article: article!)
    }
}


extension EditArticleViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image : UIImage = info[.originalImage] as? UIImage{
            self.articleImageView.image = image
        }
        self.imagePicker?.dismiss(animated: true, completion: nil)
    }
}
