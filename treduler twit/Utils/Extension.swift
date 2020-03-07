//
//  Extension.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/06.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    static let mainBlue = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
    static let tre = UIColor(displayP3Red: 29, green: 161, blue: 242, alpha: 1)
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}


extension Date {

func getElapsedInterval() -> String {

    let interval = Calendar.current.dateComponents([.year, .month, .day], from: self, to: Date())

    if let year = interval.year, year > 0 {
        return year == 1 ? "\(year)" + " " + "year ago" :
            "\(year)" + " " + "years ago"
    } else if let month = interval.month, month > 0 {
        return month == 1 ? "\(month)" + " " + "month ago" :
            "\(month)" + " " + "months ago"
    } else if let day = interval.day, day > 0 {
        return day == 1 ? "\(day)" + " " + "day ago" :
            "\(day)" + " " + "days ago"
    } else {
        return "a moment ago"

    }

}
}
