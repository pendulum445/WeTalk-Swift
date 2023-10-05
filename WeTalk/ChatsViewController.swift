//
//  ChatsViewController.swift
//  WeTalk
//
//  Created by liaoyunjie on 2023/9/29.
//

import UIKit

class ChatsViewController : UIViewController, NavigationBarViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        self.view.addSubview(self.navigationBarView)
    }
    
    func didClickNavigationBarLeftButton() {
        // TODO
    }
    
    func didClickNavigationBarFirstRightButton() {
        // TODO
    }
    
    private lazy var navigationBarView: HomeNavigationBarView = {
        let view = HomeNavigationBarView(title: "微信")
        view.delegate = self
        return view
    }()
}
