//
//  Extension.swift
//  iOSChatBotDemo
//
//  Created by Anil on 12/05/21.
//

import Foundation
import UIKit


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
