//
//  Extension.swift
//  iOSChatBotDemo
//
//  Created by Anil on 12/05/21.
//

import Foundation
import UIKit

class PaddingLabel: UILabel {

    var insets = UIEdgeInsets.zero

    func padding(_ top: CGFloat, _ bottom: CGFloat, _ left: CGFloat, _ right: CGFloat) {
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width + left + right, height: self.frame.height + top + bottom)
        insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }

//    override func drawText(in rect: CGRect) {
//        //super.drawText(in: rect.inset(by: insets))
//        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
//    }

    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += insets.top + insets.bottom
            contentSize.width += insets.left + insets.right
            return contentSize
        }
    }

}

extension UIButton{
    func methodForSetCornerRadious(){
        self.layer.cornerRadius = 20.0
        self.clipsToBounds = true
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
