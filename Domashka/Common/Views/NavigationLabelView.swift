//
//  NavigationLabelView.swift
//  Domashka
//
//  Created by Ulyana Eskova on 24.01.2025.
//

import UIKit

final class NavigationLabelView: UIView {
    // MARK: - UI Views
    private var locationIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = UIColor(named: "customBlack")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var navigationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Onest-Light", size: 13)
        label.textColor = .customBlack
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Design constants
    private enum Constants {
        static let locationIconLeftPadding: CGFloat = -10.0
        static let topPadding: CGFloat = 0.0
        static let bottomPadding: CGFloat = 0.0
        static let locationIconWidthFactor: CGFloat = 1 / 4.0
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configures
    private func configureUI() {
        addSubview(navigationLabel)
        addSubview(locationIcon)

        navigationLabel.pinLeft(to: self.leadingAnchor)
        navigationLabel.pinHorizontal(to: self)
        navigationLabel.pinCenterY(to: self.centerYAnchor)
        
        locationIcon.pinLeft(to: navigationLabel.trailingAnchor, Constants.locationIconLeftPadding)
        locationIcon.pinTop(to: self.topAnchor, Constants.topPadding)
        locationIcon.pinBottom(to: self.bottomAnchor, Constants.bottomPadding)
        locationIcon.pinWidth(to: self.widthAnchor, Constants.locationIconWidthFactor)
    }

    func configureNavigationLabelText(text: String) {
        navigationLabel.text = text
    }
}
