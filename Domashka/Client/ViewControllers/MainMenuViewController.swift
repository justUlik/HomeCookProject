//
//  MainMenuViewController.swift
//  Domashka
//
//  Created by Ulyana Eskova on 18.01.2025.
//

import UIKit

final class MainMenuViewController: UIViewController, AdressMainMenuViewDelegate {
    // MARK: - Properties
    private var viewModel: MainMenuViewModel
    private var horisontalScrollView: UIScrollView?
    private var verticalScrollView: UIScrollView!
    private var chefStackView: UIStackView!
    private var contentView: UIView!
    private var searchBarView: SearchBarView!
    private var sloganLabel = UILabel()
    private var addressMainMenuView = AdressMainMenuView()
    private var chefCardView = ChefCardView()

    // MARK: - Constants
    private enum UIConstants {
        static let addressTopPadding: CGFloat = 0
        static let addressSidePadding: CGFloat = 16
        static let addressHeight: CGFloat = 40
        
        static let sloganTopPadding: CGFloat = 30
        static let sloganSidePadding: CGFloat = 16
        static let sloganFontSize: CGFloat = 25
        
        static let searchBarTopPadding: CGFloat = 20
        static let searchBarSidePadding: CGFloat = 16
        static let searchBarHeight: CGFloat = 44
        
        static let horizontalScrollTopPadding: CGFloat = 44
        static let horizontalScrollSidePadding: CGFloat = 16
        
        static let chefStackTopPadding: CGFloat = 30
        static let chefStackSidePadding: CGFloat = 16
        static let chefStackBottomPadding: CGFloat = 30
        
        static let cardSpacing: CGFloat = 16
    }

    // MARK: - Initialization
    init(viewModel: MainMenuViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        viewModel.fetchData()
        addressMainMenuView.delegate = self
    }

    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = .backgroundBlue

        verticalScrollView = UIScrollView()
        verticalScrollView.showsVerticalScrollIndicator = false
        view.addSubview(verticalScrollView)
        verticalScrollView.pin(to: view)

        contentView = UIView()
        verticalScrollView.addSubview(contentView)
        contentView.pin(to: verticalScrollView)
        contentView.pinWidth(to: verticalScrollView)

        contentView.addSubview(addressMainMenuView)
        contentView.addSubview(sloganLabel)

        addressMainMenuView.pinTop(to: contentView.safeAreaLayoutGuide.topAnchor, UIConstants.addressTopPadding)
        addressMainMenuView.pinLeft(to: contentView.leadingAnchor, UIConstants.addressSidePadding)
        addressMainMenuView.pinRight(to: contentView.trailingAnchor, UIConstants.addressSidePadding)
        addressMainMenuView.setHeight(mode: .equal, UIConstants.addressHeight)

        sloganLabel.pinTop(to: addressMainMenuView.bottomAnchor, UIConstants.sloganTopPadding)
        sloganLabel.text = "Еда, приготовленная с любовью"
        sloganLabel.font = UIFont(name: "Onest-Medium", size: UIConstants.sloganFontSize)
        sloganLabel.textColor = .customBlack
        sloganLabel.pinHorizontal(to: contentView, UIConstants.sloganSidePadding)
        sloganLabel.numberOfLines = 2

        searchBarView = SearchBarView()
        contentView.addSubview(searchBarView)
        searchBarView.pinTop(to: sloganLabel.bottomAnchor, UIConstants.searchBarTopPadding)
        searchBarView.pinLeft(to: contentView, UIConstants.searchBarSidePadding)
        searchBarView.pinRight(to: contentView, UIConstants.searchBarSidePadding)
        searchBarView.setHeight(mode: .equal, UIConstants.searchBarHeight)

        let horisontalScrollView = UIScrollView()
        horisontalScrollView.showsHorizontalScrollIndicator = false
        contentView.addSubview(horisontalScrollView)
        horisontalScrollView.pinTop(to: searchBarView.bottomAnchor, UIConstants.horizontalScrollTopPadding)
        horisontalScrollView.pinLeft(to: contentView)
        horisontalScrollView.pinRight(to: contentView)

        let horizontalContentView = UIView()
        horisontalScrollView.addSubview(horizontalContentView)
        horizontalContentView.pin(to: horisontalScrollView)
        horizontalContentView.pinHeight(to: horisontalScrollView)

        self.horisontalScrollView = horisontalScrollView

        chefStackView = UIStackView()
        chefStackView.axis = .vertical
        chefStackView.spacing = UIConstants.cardSpacing
        chefStackView.alignment = .fill
        chefStackView.distribution = .equalSpacing
        
        contentView.addSubview(chefStackView)
        chefStackView.pinTop(to: horisontalScrollView.bottomAnchor, UIConstants.chefStackTopPadding)
        chefStackView.pinLeft(to: contentView.safeAreaLayoutGuide.leadingAnchor, UIConstants.chefStackSidePadding)
        chefStackView.pinRight(to: contentView.trailingAnchor, UIConstants.chefStackSidePadding)
        chefStackView.pinBottom(to: contentView.bottomAnchor, UIConstants.chefStackBottomPadding)
    }

    // MARK: - ViewModel Binding
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            self?.updateDishCards()
            self?.updateChefCards()
        }
    }

    // MARK: - Update UI
    private func updateDishCards() {
        horisontalScrollView?.subviews.forEach { $0.removeFromSuperview() }
        guard let horisontalScrollView = horisontalScrollView else { return }

        let contentView = UIView()
        horisontalScrollView.addSubview(contentView)
        contentView.pin(to: horisontalScrollView)
        contentView.pinHeight(to: horisontalScrollView)

        let dishes = viewModel.bestDishes
        var previousCard: UIView? = nil

        for dish in dishes {
            let card = DishCardView()
            card.cardSize = .maxi
            card.setDishImage(dishImage: UIImage(named: "Dish"), chefImage: UIImage(named: "Chef"))
            card.updateData(with: dish)
            contentView.addSubview(card)
            card.pinTop(to: contentView)
            card.pinHeight(to: contentView)
            if let previousCard = previousCard {
                card.pinLeft(to: previousCard.trailingAnchor, UIConstants.cardSpacing)
            } else {
                card.pinLeft(to: contentView, UIConstants.cardSpacing)
            }
            previousCard = card
        }

        previousCard?.pinRight(to: contentView, UIConstants.cardSpacing)
    }
    
    private func updateChefCards() {
        chefStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for chef in viewModel.chefs {
            let card = ChefCardView()
            card.setChefImage(chefImage: UIImage(named: "Chef"))
            card.updateData(with: chef)
            chefStackView.addArrangedSubview(card)
        }
    }
    
    // MARK: - Navigation
    func didTapAddressView() {
        let addressChooseOnMapController = AddressChooseOnMapController()
        navigationController?.pushViewController(addressChooseOnMapController, animated: true)
    }
}
