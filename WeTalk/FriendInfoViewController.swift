//
//  FriendInfoViewController.swift
//  WeTalk
//
//  Created by liaoyunjie on 2024/6/7.
//

import UIKit

class FriendInfoViewController: UIViewController {
    private var friendInfo: FriendInfo!

    // MARK: Life Cycle

    init(friendInfo: FriendInfo) {
        super.init(nibName: nil, bundle: nil)
        self.friendInfo = friendInfo
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)
    }
}
