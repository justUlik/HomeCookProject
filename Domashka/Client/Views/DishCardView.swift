//
//  DishCardView.swift
//  Domashka
//
//  Created by Ulyana Eskova on 17.01.2025.
//

import UIKit

enum DishCardViewSize {
    case maxi
    case midi
    case small
}

final class DishCardView: UIView {
    // MARK: - Design constants
    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let borderWidth: CGFloat = 4
        static let chefImageHeightRatio: CGFloat = 0.4
        static let chefImageWidthRatio: CGFloat = 0.25
        static let imagesViewHeightRatio: CGFloat = 0.4
        static let maxiWidthRation: CGFloat = 0.475
        static let maxiHeightRation: CGFloat = 0.39
        static let midiWidthRation: CGFloat = 0.44
        static let midiHeightRation: CGFloat = 0.34
        static let smallWidthRation: CGFloat = 0.36
        static let smallHeightRation: CGFloat = 0.19
        static let badgesStackViewTopOffset: CGFloat = 16
        static let contentLeftOffset: CGFloat = 12
        static let badgeFontSize: CGFloat = 11
        static let badgeVerticalInsents: CGFloat = 4
        static let badgeHorisontalInsents: CGFloat = 10
        static let badgesStackViewSpacing: CGFloat = 8
        static let nameLabelTopOffset: CGFloat = 12
        static let nameLabelFontSizeBig: CGFloat = 16
        static let nameLabelFontSizeSmall: CGFloat = 13
        static let ratingFontSize: CGFloat = 13
        static let ratingViewTopOffset: CGFloat = 20
        static let starWidth: CGFloat = 16
        static let starHeight: CGFloat = 16
        static let priceFontSize: CGFloat = 13
        static let priceFontSizeSmall: CGFloat = 10
        static let priceBottomOffset: CGFloat = 20
        static let priceTopInset: CGFloat = 6
        static let priceBottomInset: CGFloat = 6
        static let priceLeftInset: CGFloat = 16
        static let priceRightInset: CGFloat = 16
    }

    // MARK: - UI Elements
    private let dishImageView = UIImageView()
    private let chefImageView = UIImageView()
    private let imagesView = UIView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let ratingView = UIView()
    private let ratingLabel = UILabel()
    private let price = PaddingLabel()
    private let badgesStackView = UIStackView()
    
    // MARK: - Public Properties
    var cardSize: DishCardViewSize = .maxi {
        didSet {
            configureUI()
        }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        self.layer.cornerRadius = Constants.cornerRadius
        self.layer.masksToBounds = true
        self.removeAllConstraints()
        let calcCardSize = calculateCardSize(for: cardSize)
        self.setWidth(calcCardSize.width)
        self.setHeight(calcCardSize.height)
        
        switch cardSize {
        case .small:
            configureForSmall()
        case .midi, .maxi:
            configureForStandard()
        }
    }

    private func configureForStandard() {
        self.backgroundColor = .customWhite
        configureImages(isSmall: false)
        configureBadges()
        configureDishName(isSmall: false)
        configureRating()
        configurePriceBig()
    }

    private func configureForSmall() {
        self.backgroundColor = .backgroundBlue
        ratingView.removeFromSuperview()
        price.removeFromSuperview()
        badgesStackView.removeFromSuperview()
        configureImages(isSmall: true)
        configureDishName(isSmall: true)
        configurePriceSmall()
    }

    private func configureImages(isSmall: Bool) {
        self.addSubview(imagesView)
        imagesView.layer.cornerRadius = Constants.cornerRadius
        imagesView.clipsToBounds = true
        imagesView.pinHeight(to: self.heightAnchor, Constants.imagesViewHeightRatio)
        imagesView.pinHorizontal(to: self)
        imagesView.pinTop(to: self.topAnchor)

        imagesView.addSubview(dishImageView)
        dishImageView.pin(to: imagesView)
        dishImageView.contentMode = .scaleAspectFill

        if !isSmall {
            imagesView.addSubview(chefImageView)
            chefImageView.contentMode = .scaleAspectFill
            chefImageView.clipsToBounds = true
            chefImageView.layer.cornerRadius = Constants.cornerRadius
            chefImageView.layer.masksToBounds = true
            chefImageView.layer.borderWidth = Constants.borderWidth
            chefImageView.layer.borderColor = UIColor(named: "customGray")?.cgColor

            chefImageView.pinBottom(to: imagesView.bottomAnchor)
            chefImageView.pinRight(to: imagesView.trailingAnchor)
            chefImageView.pinWidth(to: imagesView.widthAnchor, Constants.chefImageWidthRatio)
            chefImageView.pinHeight(to: imagesView.heightAnchor, Constants.chefImageHeightRatio)
        }
    }

    private func configureBadges() {
        self.addSubview(badgesStackView)
        badgesStackView.axis = .horizontal
        badgesStackView.spacing = Constants.badgesStackViewSpacing
        badgesStackView.alignment = .leading
        badgesStackView.distribution = .fillProportionally
        badgesStackView.pinTop(to: imagesView.bottomAnchor, Constants.badgesStackViewTopOffset)
        badgesStackView.pinLeft(to: self, Constants.contentLeftOffset)
    }

    private func createBadge(with text: String) -> UILabel {
        let label = PaddingLabel()
        label.font = UIFont(name: "Onest-Regular", size: Constants.badgeFontSize)
        label.textColor = .customBlack
        label.textAlignment = .center
        label.layer.cornerRadius = Constants.cornerRadius
        label.layer.masksToBounds = true
        label.backgroundColor = .customGray
        label.text = text
        label.topInset = Constants.badgeVerticalInsents
        label.bottomInset = Constants.badgeVerticalInsents
        label.leftInset = Constants.badgeHorisontalInsents
        label.rightInset = Constants.badgeHorisontalInsents
        return label
    }

    private func configureDishName(isSmall: Bool) {
        self.addSubview(nameLabel)
        nameLabel.textColor = .customBlack
        nameLabel.numberOfLines = 2
        nameLabel.pinHorizontal(to: self, Constants.contentLeftOffset)
        
        if (isSmall) {
            nameLabel.pinTop(to: imagesView.bottomAnchor, Constants.nameLabelTopOffset)
            nameLabel.font = UIFont(name: "Onest-Regular", size: Constants.nameLabelFontSizeSmall)
        } else {
            nameLabel.pinTop(to: badgesStackView.bottomAnchor, Constants.nameLabelTopOffset)
            nameLabel.font = UIFont(name: "Onest-Regular", size: Constants.nameLabelFontSizeBig)
        }
    }

    private func configureRating() {
        self.addSubview(ratingView)
        ratingView.pinTop(to: nameLabel.bottomAnchor, Constants.ratingViewTopOffset)
        ratingView.pinLeft(to: self, Constants.contentLeftOffset)

        ratingLabel.font = UIFont(name: "Onest-Regular", size: Constants.ratingFontSize)
        ratingLabel.textColor = .black

        let iconView = UIImageView()
        iconView.image = UIImage(systemName: "star.fill")
        iconView.tintColor = .accentOrange
        iconView.contentMode = .scaleAspectFit

        ratingView.addSubview(iconView)
        ratingView.addSubview(ratingLabel)

        iconView.pinLeft(to: ratingView.leadingAnchor)
        iconView.pinCenterY(to: ratingView.centerYAnchor)
        iconView.setWidth(Constants.starWidth)
        iconView.setHeight(Constants.starHeight)

        ratingLabel.pinLeft(to: iconView.trailingAnchor, 4)
        ratingLabel.pinCenterY(to: ratingView.centerYAnchor)
    }

    private func configurePriceBig() {
        self.addSubview(price)
        price.pinLeft(to: self.leadingAnchor, Constants.contentLeftOffset)
        price.pinBottom(to: self.bottomAnchor, Constants.priceBottomOffset)
        price.font = UIFont(name: "Onest-Medium", size: Constants.priceFontSize)
        price.textColor = .backgroundBlue
        price.textAlignment = .center
        price.layer.cornerRadius = Constants.cornerRadius
        price.layer.masksToBounds = true
        price.backgroundColor = .accentOrange
        price.topInset = Constants.priceTopInset
        price.bottomInset = Constants.priceBottomInset
        price.leftInset = Constants.priceLeftInset
        price.rightInset = Constants.priceRightInset
    }
    
    private func configurePriceSmall() {
        self.addSubview(price)
        price.pinHorizontal(to: self, Constants.contentLeftOffset)
        price.pinBottom(to: self.bottomAnchor, Constants.priceBottomOffset)
        price.font = UIFont(name: "Onest-Medium", size: Constants.priceFontSizeSmall)
        price.textColor = .backgroundBlue
        price.textAlignment = .center
        price.layer.cornerRadius = Constants.cornerRadius
        price.layer.masksToBounds = true
        price.backgroundColor = .accentOrange
        
        price.topInset = Constants.priceTopInset
        price.bottomInset = Constants.priceBottomInset
        price.leftInset = Constants.priceLeftInset
        price.rightInset = Constants.priceRightInset
    }

    private func updateBadges(with badges: [String]) {
        badgesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for badge in badges {
            let badgeLabel = createBadge(with: badge)
            badgesStackView.addArrangedSubview(badgeLabel)
        }
    }

    func calculateCardSize(for size: DishCardViewSize) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        switch size {
        case .maxi:
            return CGSize(width: screenWidth * Constants.maxiWidthRation, height: screenHeight * Constants.maxiHeightRation)
        case .midi:
            return CGSize(width: screenWidth * Constants.midiWidthRation, height: screenHeight * Constants.midiHeightRation)
        case .small:
            return CGSize(width: screenWidth * Constants.smallWidthRation, height: screenHeight * Constants.smallHeightRation)
        }
    }

    // MARK: - Public Methods
    func setDishImage(dishImage: UIImage?, chefImage: UIImage?) {
        dishImageView.image = dishImage
        chefImageView.image = chefImage
    }
    
    func setDishImage(dishImage: UIImage?) {
        dishImageView.image = dishImage
    }

    func updateData(with dish: Dish) {
        nameLabel.text = dish.name
        updateBadges(with: ["\(dish.deliveryTimeMin)-\(dish.deliveryTimeMax) мин"])
        ratingLabel.text = String(dish.rating)
        price.text = "+ от \(dish.price)₽"
    }
}
