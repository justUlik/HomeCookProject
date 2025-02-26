import UIKit

final class ChefCardView: UIView {
    // MARK: - UI Elements
    private let chefBioAndMenuButtonView = UIView()
    private let chefImageView = UIImageView()
    private let chefName = UILabel()
    private let chefSurname = UILabel()
    private let navigationLabelView = NavigationLabelView()
    private let badgesStackView = UIStackView()
    private let reviewView = UIView()
    private let reviewAuthor = UILabel()
    private let reviewText = UILabel()
    private let dishesScrollView = UIScrollView()
    private let dishesStackView = UIStackView()

    // MARK: - Design constants
    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let maxiHeightRation: CGFloat = 0.45
        static let chefImageCornerRadius: CGFloat = 20
        static let badgesStackViewTopOffset: CGFloat = 16
        static let badgeFontSize: CGFloat = 11
        static let badgeVerticalInsents: CGFloat = 4
        static let badgeHorisontalInsents: CGFloat = 10
        static let badgesStackViewSpacing: CGFloat = 8
        static let dishCardSpacing: CGFloat = 16
        
        static let chefBioAndMenuButtonHorizontalPadding: CGFloat = 16
        static let chefBioAndMenuButtonTopPadding: CGFloat = 18
        static let chefImageSize: CGFloat = 74
    
        static let chefNameFontSize: CGFloat = 17
        static let chefSurnameFontSize: CGFloat = 13
        static let chefTextLeftPadding: CGFloat = 12
        static let nameToSurnameSpacing: CGFloat = 1
        
        static let reviewHorizontalPadding: CGFloat = 16
        static let reviewTopPadding: CGFloat = 20
        static let reviewHeight: CGFloat = 80
        static let reviewCornerRadius: CGFloat = 8
        static let reviewAuthorLeftPadding: CGFloat = 16
        static let reviewAuthorTopPadding: CGFloat = 10
        static let reviewAuthorFontSize: CGFloat = 13
        static let reviewTextLeftPadding: CGFloat = 16
        static let reviewTextTopPadding: CGFloat = 4
        static let reviewTextRightPadding: CGFloat = 16
        static let reviewTextFontSize: CGFloat = 13
        
        static let dishesScrollViewTopPadding: CGFloat = 15
        static let dishesScrollViewSidePadding: CGFloat = 16
        static let dishesStackViewSpacing: CGFloat = 10
        
    }

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    // MARK: - UI Configurations
    private func configureUI() {
        self.backgroundColor = .customWhite
        self.layer.cornerRadius = Constants.cornerRadius
        self.layer.masksToBounds = true
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let cardSize = CGSize(width: screenWidth - 16 * 2, height: screenHeight * Constants.maxiHeightRation)
        self.setWidth(cardSize.width)
        self.setHeight(cardSize.height)
        
        confgireChefBioAndMenuButton()
        configureBadges()
        configureReview()
        configureDishes()
    }

    private func confgireChefBioAndMenuButton() {
        self.addSubview(chefBioAndMenuButtonView)
        chefBioAndMenuButtonView.pinHorizontal(to: self, Constants.chefBioAndMenuButtonHorizontalPadding)
        chefBioAndMenuButtonView.pinTop(to: self.topAnchor, Constants.chefBioAndMenuButtonTopPadding)
        chefBioAndMenuButtonView.setHeight(Constants.chefImageSize)
        
        chefBioAndMenuButtonView.addSubview(chefImageView)
        chefImageView.clipsToBounds = true
        chefImageView.layer.cornerRadius = Constants.chefImageCornerRadius
        chefImageView.contentMode = .scaleAspectFill
        chefImageView.pinLeft(to: chefBioAndMenuButtonView.leadingAnchor, .zero)
        chefImageView.pinTop(to: chefBioAndMenuButtonView.topAnchor, .zero)
        chefImageView.pinBottom(to: chefBioAndMenuButtonView.bottomAnchor, .zero)
        chefImageView.setHeight(Constants.chefImageSize)
        chefImageView.setWidth(Constants.chefImageSize)
        
        chefBioAndMenuButtonView.addSubview(chefName)
        chefName.font = UIFont(name: "Onest-Medium", size: Constants.chefNameFontSize)
        chefName.numberOfLines = 0
        chefName.lineBreakMode = .byWordWrapping
        chefName.textColor = .customBlack
        chefName.pinLeft(to: chefImageView.trailingAnchor, Constants.chefTextLeftPadding)
        chefName.pinTop(to: chefBioAndMenuButtonView.topAnchor, .zero)
        
        chefBioAndMenuButtonView.addSubview(chefSurname)
        chefSurname.font = UIFont(name: "Onest-Medium", size: Constants.chefSurnameFontSize)
        chefSurname.numberOfLines = 0
        chefSurname.lineBreakMode = .byWordWrapping
        chefSurname.textColor = .customBlack
        chefSurname.pinLeft(to: chefImageView.trailingAnchor, Constants.chefTextLeftPadding)
        chefSurname.pinTop(to: chefName.bottomAnchor, Constants.nameToSurnameSpacing)
        
        chefBioAndMenuButtonView.addSubview(navigationLabelView)
        navigationLabelView.configureNavigationLabelText(text: "Меню")
        navigationLabelView.pinRight(to: chefBioAndMenuButtonView.trailingAnchor, .zero)
        navigationLabelView.pinTop(to: chefBioAndMenuButtonView.topAnchor)
    }

    private func configureBadges() {
        chefBioAndMenuButtonView.addSubview(badgesStackView)
        badgesStackView.axis = .horizontal
        badgesStackView.spacing = Constants.badgesStackViewSpacing
        badgesStackView.alignment = .leading
        badgesStackView.distribution = .fillProportionally
        badgesStackView.pinBottom(to: chefBioAndMenuButtonView.bottomAnchor)
        badgesStackView.pinLeft(to: chefImageView.trailingAnchor, Constants.chefTextLeftPadding)
    }
    
    private func configureReview() {
        self.addSubview(reviewView)
        reviewView.pinHorizontal(to: self, Constants.reviewHorizontalPadding)
        reviewView.pinTop(to: chefBioAndMenuButtonView.bottomAnchor, Constants.reviewTopPadding)
        reviewView.setHeight(Constants.reviewHeight)
        
        reviewView.backgroundColor = .backgroundBlue
        reviewView.layer.cornerRadius = Constants.reviewCornerRadius
        
        reviewView.addSubview(reviewAuthor)
        reviewAuthor.pinLeft(to: reviewView.leadingAnchor, Constants.reviewAuthorLeftPadding)
        reviewAuthor.pinTop(to: reviewView.topAnchor, Constants.reviewAuthorTopPadding)
        reviewAuthor.font = UIFont(name: "Onest-Medium", size: Constants.reviewAuthorFontSize)
        reviewAuthor.textColor = .customBlack
        reviewAuthor.numberOfLines = 1
        
        reviewView.addSubview(reviewText)
        reviewText.pinLeft(to: reviewView.leadingAnchor, Constants.reviewTextLeftPadding)
        reviewText.pinTop(to: reviewAuthor.bottomAnchor, Constants.reviewTextTopPadding)
        reviewText.pinRight(to: reviewView.trailingAnchor, Constants.reviewTextRightPadding)
        reviewText.font = UIFont(name: "Onest-Regular", size: Constants.reviewTextFontSize)
        reviewText.textColor = .customBlack
        reviewText.numberOfLines = 2
    }

    private func configureDishes() {
        self.addSubview(dishesScrollView)
        dishesScrollView.pinTop(to: reviewView.bottomAnchor, Constants.dishesScrollViewTopPadding)
        dishesScrollView.pinLeft(to: self, Constants.dishesScrollViewSidePadding)
        dishesScrollView.pinRight(to: self, Constants.dishesScrollViewSidePadding)
        
        dishesScrollView.addSubview(dishesStackView)
        dishesStackView.axis = .horizontal
        dishesStackView.spacing = Constants.dishesStackViewSpacing

        dishesStackView.pin(to: dishesScrollView)
    }

    // MARK: - Badge Creation
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

    private func updateBadges(with badges: [String]) {
        badgesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for badge in badges {
            let badgeLabel = createBadge(with: badge)
            badgesStackView.addArrangedSubview(badgeLabel)
        }
    }

    // MARK: - Dish Card Creation
    private func createDishCard(for dish: Dish) -> DishCardView {
        let dishCard = DishCardView()
        dishCard.cardSize = .small
        dishCard.translatesAutoresizingMaskIntoConstraints = false
        let cardSize = dishCard.calculateCardSize(for: DishCardViewSize.small)
        dishCard.setWidth(cardSize.width)
        dishCard.setHeight(cardSize.height)
        dishCard.setDishImage(dishImage: UIImage(named: "Dish"), chefImage: UIImage(named: "Chef"))
        dishCard.updateData(with: dish)
        return dishCard
    }
    
    func setChefImage(chefImage: UIImage?) {
        chefImageView.image = chefImage
    }

    // MARK: - Chef Data Update
    func updateData(with chef: Chef) {
        chefName.text = chef.name
        chefSurname.text = chef.surname
        updateBadges(with: ["15-20 мин", "Мед.книжка"])
        reviewAuthor.text = "Ульяна"
        reviewText.text = "Mock review example"

        dishesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for dish in chef.menu {
            let dishCard = createDishCard(for: dish)
            dishCard.setDishImage(dishImage: UIImage(named: "Dish"))
            dishesStackView.addArrangedSubview(dishCard)
            dishCard.backgroundColor = .red
            dishCard.pinTop(to: dishesStackView)
        }
    }
}

