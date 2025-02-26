//
//  AdressMainMenuView.swift
//  Domashka
//
//  Created by Ulyana Eskova on 20.01.2025.
//

import UIKit

protocol AdressMainMenuViewDelegate: AnyObject {
    func didTapAddressView()
}

final class AdressMainMenuView: UIView {
    weak var delegate: AdressMainMenuViewDelegate?
    
    private enum Constants {
        static let locationIconWidthMultiplier: CGFloat = 1 / 8
        static let addressLabelLeftPadding: CGFloat = 8
        static let addressFontSize: CGFloat = 17
        static let defaultAddressText: String = "ул. Рождественская, д. 34"
    }
    
    private var locationIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
        imageView.tintColor = UIColor(named: "accentOrange")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Onest-Medium", size: Constants.addressFontSize)
        label.textColor = .customBlack
        label.numberOfLines = 1
        label.text = Constants.defaultAddressText
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureTapGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(locationIcon)
        addSubview(addressLabel)
        
        locationIcon.pinLeft(to: self.leadingAnchor)
        locationIcon.pinTop(to: self.topAnchor)
        locationIcon.pinBottom(to: self.bottomAnchor)
        locationIcon.pinWidth(to: self.widthAnchor, Constants.locationIconWidthMultiplier)
        
        addressLabel.pinLeft(to: locationIcon.trailingAnchor, Constants.addressLabelLeftPadding)
        addressLabel.pinRight(to: self.trailingAnchor)
        addressLabel.pinCenterY(to: self.centerYAnchor)
    }

    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }
    
    @objc private func handleTap() {
        delegate?.didTapAddressView()
    }
}
