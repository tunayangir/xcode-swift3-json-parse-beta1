//
//  WebviewViewController.swift
//  json2
//
//  Created by TunaYANGIR on 9.12.2016.
//  Copyright © 2016 TunaYANGIR. All rights reserved.
//

import UIKit

class WebviewViewController: UIViewController {

    
    @IBOutlet weak var webview: UIWebView!
    
    var url:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webview.loadRequest(URLRequest(url: URL(string:url!)!))
        
        

    }

}
