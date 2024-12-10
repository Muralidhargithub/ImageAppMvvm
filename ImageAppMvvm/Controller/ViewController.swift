//
//  ViewController.swift
//  ImageAppMvvm
//
//  Created by Muralidhar reddy Kakanuru on 12/9/24.
//


import UIKit

class ViewController: UIViewController {
    
    let tableView = PhotoController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        view.largeContentTitle = "Subscriber App"
    }
    func setUp(){
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }


}
