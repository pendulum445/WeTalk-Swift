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
}
