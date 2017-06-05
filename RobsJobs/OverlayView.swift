//
//  OverlayView.swift
//  TinderSwipeCardsSwift
//
//  Created by Gao Chao on 4/30/15.
//  Copyright (c) 2015 gcweb. All rights reserved.
//

import Foundation
import UIKit

enum GGOverlayViewMode {
    case GGOverlayViewModeLeft
    case GGOverlayViewModeRight
}

class OverlayView: UIView{
    var _mode: GGOverlayViewMode! = GGOverlayViewMode.GGOverlayViewModeLeft
    var imageView: UIImageView!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        imageView = UIImageView(image: UIImage(named: "RJ_jobs_pass_stamp"))
        self.addSubview(imageView)
    }

    func setMode(mode: GGOverlayViewMode) -> Void {
        if _mode == mode {
            return
        }
        _mode = mode

        if _mode == GGOverlayViewMode.GGOverlayViewModeLeft {
            imageView.image = UIImage(named: "RJ_jobs_pass_stamp")
        } else {
            imageView.image = UIImage(named: "RJ_jobs_apply_stamp")
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 50,y: 50,width: 100,height: 100)
    }
}
