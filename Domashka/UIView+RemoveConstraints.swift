//
//  UIView+RemoveConstraints.swift
//  Domashka
//
//  Created by Ulyana Eskova on 25.01.2025.
//

import UIKit

extension UIView {
    func removeAllConstraints() {
        self.removeConstraints(self.constraints)
    }
}
