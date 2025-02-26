//
//  SearchBarView.swift
//  Domashka
//
//  Created by Ulyana Eskova on 20.01.2025.
//

import UIKit

protocol SearchBarViewDelegate: AnyObject {
    func searchBar(_ searchBar: SearchBarView, textDidChange text: String)
    func searchBarShouldBeginEditing(_ searchBar: SearchBarView) -> Bool
    func searchBarShouldEndEditing(_ searchBar: SearchBarView)
}


class SearchBarView: UIView, UITextFieldDelegate {
    // MARK: - UI Views
    private let searchTextField = UITextField()
    
    // MARK: - Delegate
    weak var delegate: SearchBarViewDelegate?

    // MARK: - Design constants
    private enum Constants {
        static let cornerRadiusForBigElem: CGFloat = 12.0
        static let fontSizeForSearchTextField: CGFloat = 14.0
        static let paddingWidthForSearchIcon: CGFloat = 24.0
        static let imageViewXPosition: CGFloat = 4.0
        static let topPadding: CGFloat = 0.0
        static let bottomPadding: CGFloat = 0.0
        static let leftPadding: CGFloat = 16.0
        static let rightPadding: CGFloat = 16.0
    }

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
        
        searchTextField.delegate = self
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    // MARK: - Configures
    private func configureUI() {
        self.backgroundColor = .customWhite
        self.layer.cornerRadius = Constants.cornerRadiusForBigElem

        let placeholderText = "Повара, блюда, кухни"
        self.setTextPlaceHolder(text: placeholderText)
        searchTextField.clearButtonMode = .whileEditing
        let searchImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchImageView.tintColor = .customBlack
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.paddingWidthForSearchIcon, height: searchImageView.frame.height))
        searchImageView.frame.origin = CGPoint(x: Constants.imageViewXPosition, y: 0)
        paddingView.addSubview(searchImageView)
        searchTextField.leftView = paddingView
        searchTextField.leftViewMode = .always
        searchTextField.textColor = .customBlack
        
        self.addSubview(searchTextField)
        
        searchTextField.pinTop(to: self.topAnchor, Constants.topPadding)
        searchTextField.pinBottom(to: self.bottomAnchor, Constants.bottomPadding)
        searchTextField.pinLeft(to: self.leadingAnchor, Constants.leftPadding)
        searchTextField.pinRight(to: self.trailingAnchor, Constants.rightPadding)
    }
    
    // MARK: - Actions
    @objc private func handleTap() {
        searchTextField.becomeFirstResponder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate?.searchBar(self, textDidChange: textField.text ?? "")
    }
    
    func setTextPlaceHolder(text: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.customBlack,
            .font: UIFont(name: "Onest-Regular", size: Constants.fontSizeForSearchTextField) ?? UIFont.systemFont(ofSize: Constants.fontSizeForSearchTextField)
        ]
        searchTextField.attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.searchBarShouldEndEditing(self)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return delegate?.searchBarShouldBeginEditing(self) ?? true
    }
}
