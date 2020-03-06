//
//  CaptionTextView.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/07.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class CaptionTextView: UITextView, UITextViewDelegate {

    lazy var placeholderLabel:UILabel = {
        let label = UILabel()
        label.text = "What's happening?"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.addSubview(placeholderLabel)
        delegate = self
        autocorrectionType = .no
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = true
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 7).isActive = true
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
