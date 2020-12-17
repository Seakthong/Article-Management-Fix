//
//  ViewArticleViewController.swift
//  Article Management
//
//  Created by SQ on 12/26/19.
//  Copyright © 2019 SQ. All rights reserved.
//

import UIKit
import SCLAlertView

class ViewArticleViewController: UIViewController {
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleDateLabel: UILabel!
    @IBOutlet weak var articleViewCountLabel: UILabel!
    @IBOutlet weak var articleTypeLabel: UILabel!
    @IBOutlet weak var articleDescriptionTextView: UITextView!
    
    var article : Article?
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeView()
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.imageViewLongPressed(_:)))
        articleImageView.addGestureRecognizer(longPressGesture)
        articleImageView.isUserInteractionEnabled = true
    }
    
    // MARK: - Save Image To Library
     @IBAction func imageViewLongPressed(_ longPress: UILongPressGestureRecognizer) {
            guard longPress.state == .ended else { return }
        let alert = UIAlertController(title: "Do you want to Save?", message: nil, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default){(action) in
            DispatchQueue.main.async {
                if let image = self.articleImageView.image{
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveImageToLibrary(image:didFinishSavingWithError:contextInfo:)), nil)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
        
    @objc func saveImageToLibrary(image: UIImage!, didFinishSavingWithError error: NSError!, contextInfo: AnyObject!) {
        if error == nil {
            // saved
            print("save photo success")
        } else {
            // NONE
            print("save photo wrong")
        }
    }
    
    func customizeView(){
        articleImageView.layer.borderWidth = 1.0
        articleImageView.layer.borderColor = UIColor.blue.cgColor
    }
    
    //MARK: - When View Appear make it have data to show
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if article!.image == ""{
            self.articleImageView.image = UIImage()
        }
        else if let image = article!.image{
            let url = URL(string: image)
            self.articleImageView.kf.setImage(with: url)
        }
        
        self.articleTitleLabel.text = (article?.title == "" ? "NO TITLE" : article?.title)
        self.articleDateLabel.text = "DATE : \((article?.date)!)"
        self.articleViewCountLabel.text = "|  \((article?.viewCount)!)"
        self.articleTypeLabel.text = "AUTHOR : \((article?.author)!)"
        self.articleDescriptionTextView.text = "\((article?.description)!)"
    }

}
