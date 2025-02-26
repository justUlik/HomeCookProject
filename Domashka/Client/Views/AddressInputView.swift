//
//  AddressInputView.swift
//  Domashka
//
//  Created by Ulyana Eskova on 16.02.2025.
//

import UIKit
import MapKit

final class AddressInputView: UIView, SearchBarViewDelegate {
    var onTextChanged: ((String) -> Void)?
    var onStartEditing: (() -> Void)?
    var onButtonPressed: (() -> Void)?
    
    private var headingLabel = UILabel()
    private var addressInput = UIView()
    private var placeholderLabel = UILabel()
    private var inputCaptionLabel = UILabel()
    private var button = UIButton()
    
    private var suggestionsView: AddressSuggestionsView?
    
    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let viewWidth: CGFloat = UIScreen.main.bounds.width
        static let viewHeight: CGFloat = UIScreen.main.bounds.height * 0.3
        static let headingLabelTopOffset: CGFloat = 16
        static let leftOffset: CGFloat = 16
        static let headingLabelText: String = "Укажите адрес на карте"
        static let headingLabelFontSize: CGFloat = 20
        static let addressInputText: String = "Адрес"
        static let addressInputTopOffset: CGFloat = 20
        static let addressInputHeight: CGFloat = 46
        static let inputCaptionText: String = "Время доставки зависит от выбора блюд"
        static let inputCaptionFontSize: CGFloat = 13
        static let inputCaptionTopOffset: CGFloat = 4
        static let buttonTopOffset: CGFloat = 40
        static let buttonHeight: CGFloat = 46
        static let buttonTitleLabelText: String = "Заказать сюда"
        static let buttonTitleLableFontSize: CGFloat = 17
        static let buttonButtonOffset: CGFloat = 16
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    
    private func configureUI() {
        self.backgroundColor = UIColor(named: "backgroundBlue")
        self.layer.cornerRadius = Constants.cornerRadius
        self.layer.masksToBounds = true
        
        
        self.setWidth(Constants.viewWidth)
        self.setHeight(Constants.viewHeight)
        
        configureHeadingLabel()
        configureAddressInput()
        configureInputCaption()
        configureButton()
    }
    
    private func configureHeadingLabel() {
        self.addSubview(headingLabel)
        headingLabel.pinLeft(to: self.safeAreaLayoutGuide.leadingAnchor, Constants.leftOffset)
        headingLabel.pinTop(to: self.topAnchor, Constants.headingLabelTopOffset)
        headingLabel.text = Constants.headingLabelText
        headingLabel.textColor = .customBlack
        headingLabel.font = UIFont(name: "Onest-Medium", size: Constants.headingLabelFontSize)
    }
    
    private func configureAddressInput() {
        self.addSubview(addressInput)
        addressInput.pinTop(to: headingLabel.bottomAnchor, Constants.addressInputTopOffset)
        addressInput.pinHorizontal(to: self, Constants.leftOffset)
        addressInput.setHeight(Constants.addressInputHeight)
        addressInput.backgroundColor = .customLightGray
        addressInput.layer.cornerRadius = Constants.cornerRadius
        
        let searchImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchImageView.tintColor = .customBlack
        addressInput.addSubview(searchImageView)
        
        searchImageView.pinLeft(to: addressInput.leadingAnchor, 16)
        searchImageView.pinCenterY(to: addressInput)
        searchImageView.setHeight(20)
        searchImageView.setWidth(20)
        
        
        placeholderLabel.text = Constants.addressInputText
        placeholderLabel.textColor = .customBlack
        placeholderLabel.font = UIFont(name: "Onest-Regular", size: 14)
        placeholderLabel.frame = CGRect(x: 16, y: 0, width: addressInput.frame.width, height: addressInput.frame.height)
        addressInput.addSubview(placeholderLabel)
        placeholderLabel.pinLeft(to: searchImageView.trailingAnchor, 6)
        placeholderLabel.pinCenterY(to: addressInput)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleAddressInputTap))
        addressInput.addGestureRecognizer(tapGesture)
        
        if let searchBar = addressInput as? SearchBarView {
            searchBar.delegate = self
        }
    }
    
    private func configureInputCaption() {
        self.addSubview(inputCaptionLabel)
        
        inputCaptionLabel.pinTop(to: addressInput.bottomAnchor, Constants.inputCaptionTopOffset)
        inputCaptionLabel.pinLeft(to: self.leadingAnchor, Constants.leftOffset)
        
        inputCaptionLabel.text = Constants.inputCaptionText
        inputCaptionLabel.font = UIFont(name: "Onest-Regular", size: Constants.inputCaptionFontSize)
        inputCaptionLabel.textColor = UIColor(named: "customLightBlack")
    }
    
    private func configureButton() {
        self.addSubview(button)
        
        button.pinBottom(to: self.safeAreaLayoutGuide.bottomAnchor, Constants.buttonButtonOffset)
        button.pinHorizontal(to: self, Constants.leftOffset)
        button.setHeight(Constants.buttonHeight)
        
        button.backgroundColor = .customLightGray
        button.setTitle(Constants.buttonTitleLabelText, for: .normal)
        button.titleLabel?.font = UIFont(name: "Onest-Regular", size: Constants.buttonTitleLableFontSize)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = Constants.cornerRadius
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
    }
    
    @objc private func handleAddressInputTap() {
        if let suggestionsView = suggestionsView {
            suggestionsView.isHidden = false
        }
        onStartEditing?()
    }
    
    @objc private func handleButtonTap() {
        onButtonPressed?()
    }
    
    func updateAddress(_ address: String) {
        placeholderLabel.text = address
    }
    
    func showUnsupportedWarning() {
        inputCaptionLabel.text = "Пока мы сюда не доставляем. Работаем над этим"
        inputCaptionLabel.textColor = .red
    }
    
    func hideUnsupportedWarning() {
        inputCaptionLabel.text = Constants.inputCaptionText
        inputCaptionLabel.textColor = .customLightBlack
    }
    
    func setButtonState(isActive: Bool) {
        if (isActive) {
            button.backgroundColor = .accentOrange
            button.titleLabel?.textColor = .white
            button.isEnabled = true
        } else {
            button.backgroundColor = .customLightGray
            button.isEnabled = false
        }
    }
    
    func searchBar(_ searchBar: SearchBarView, textDidChange text: String) {
        onTextChanged?(text)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: SearchBarView) -> Bool {
        suggestionsView?.isHidden = false
        onStartEditing?()
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: SearchBarView) {
        suggestionsView?.isHidden = true
    }
}
