//
//  BetshopDeatilsView.swift
//  Betshops
//
//  Created by Luka on 04.05.2024..
//

import UIKit
import SnapKit

class BetshopDetailsView: UIView {
    
    let closeButton = UIImageView()
    let locationImage = UIImageView()
    let locationStackView = UIStackView()
    let adressLabel = UILabel()
    let countyLabel = UILabel()
    let nameLabel = UILabel()
    let openHoursLabel = UILabel()
    let routeLabel = UILabel()
    
    var betShop: Betshop?
    var close: (() -> Void)?
    var route: ((Betshop) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
        addSubview(closeButton)
        closeButton.image = Assets.Images.close
        closeButton.isUserInteractionEnabled = true
        closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeDetail)))
        
        addSubview(locationImage)
        locationImage.image = Assets.Images.location
        
        addSubview(locationStackView)
        locationStackView.addArrangedSubview(nameLabel)
        locationStackView.addArrangedSubview(adressLabel)
        locationStackView.addArrangedSubview(countyLabel)
        locationStackView.axis = .vertical
        locationStackView.alignment = .leading
        locationStackView.spacing = 5
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 0
        adressLabel.textColor = .black
        countyLabel.textColor = .black
        countyLabel.numberOfLines = 0
        
        addSubview(openHoursLabel)
        openHoursLabel.textColor = Assets.Colors.green
        openHoursLabel.textAlignment = .center
        
        addSubview(routeLabel)
        routeLabel.text = Assets.Text.route
        routeLabel.textAlignment = .center
        routeLabel.font = UIFont.boldSystemFont(ofSize: 20)
        routeLabel.textColor = Assets.Colors.blue
        routeLabel.isUserInteractionEnabled = true
        routeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showRoute)))
    }
    
    private func configureConstraints() {
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.trailing.equalTo(-10)
            make.height.width.equalTo(30)
        }
        
        locationImage.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.leading.equalTo(10)
            make.height.equalTo(25)
            make.width.equalTo(20)
        }
        
        locationStackView.snp.makeConstraints { make in
            make.top.equalTo(locationImage.snp.top)
            make.leading.equalTo(locationImage.snp.trailing).offset(20)
            make.width.equalTo(200)
        }
        
        openHoursLabel.snp.makeConstraints { make in
            make.top.equalTo(locationStackView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(20)
        }
        
        routeLabel.snp.makeConstraints { make in
            make.top.equalTo(openHoursLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    func setData(betshop: Betshop) {
        self.betShop = betshop
    
        adressLabel.text = betshop.address
        countyLabel.text = "\(betshop.city) - \(betshop.county)"
        nameLabel.text = betshop.name.removeWhitespaceIfFirst()
        
        if Date().currentTimeFormatted() > betshop.closingTime || Date().currentTimeFormatted() < betshop.openingTime {
            openHoursLabel.text = Assets.Text.opensTommorow + betshop.openingTime
        } else {
            openHoursLabel.text = Assets.Text.openNow + betshop.closingTime
        }
    }
    
    @objc func closeDetail() {
        close?()
    }
    
    @objc func showRoute() {
        guard let betShop = betShop else { return }
        route?(betShop)
    }
}
