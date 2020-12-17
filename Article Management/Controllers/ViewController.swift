//
//  ViewController.swift
//  Article Management
//
//  Created by SQ on 12/25/19.
//  Copyright © 2019 SQ. All rights reserved.
//

import UIKit

class ViewController: UINavigationController {

    @IBOutlet weak var statusBar: UINavigationBar!
    // MARK: - Change text in status bar
    override var preferredStatusBarStyle: UIStatusBarStyle{return .lightContent}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let app = UIApplication.shared
        let statusBarHeight: CGFloat = app.statusBarFrame.size.height

        let statusbarView = UIView()
        // MARK: - Change Status Bar Color
        statusbarView.backgroundColor = UIColor.systemBlue
        view.addSubview(statusbarView)
        
        statusbarView.translatesAutoresizingMaskIntoConstraints = false
        statusbarView.heightAnchor.constraint(equalToConstant: statusBarHeight).isActive = true
        statusbarView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        statusbarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        statusbarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

}
