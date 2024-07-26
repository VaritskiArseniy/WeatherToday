//
//  HourWeatherCell.swift
//  WeatherToday
//
//  Created by Арсений Варицкий on 24.07.24.
//

import Foundation
import UIKit

class HourWeatherCell: UICollectionViewCell {
    
    private enum Constants {
        static var sunIcon = { R.image.sunIcon() }
        static var cloudIcon = { R.image.cloudIcon() }
        static var rainIcon = { R.image.rainIcon() }
        static var snowIcon = { R.image.snowIcon() }
        static var thunderIcon = { R.image.thunderIcon() }
        static var moonIcon = { R.image.moonIcon() }
    }
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .black
        return label
    }()
    
    private lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubviews([
            timeLabel,
            mainImageView,
            tempLabel
        ])
    }
    
    private func setupConstraints() {
        timeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        mainImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.width.equalTo(22)
        }
        
        tempLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
    }
    
   func configure(with model: HourWeatherModel) {
       switch model.main {
       case "Rain":
           mainImageView.image = Constants.rainIcon()
           
       case "Snow":
           mainImageView.image = Constants.snowIcon()
           
       case "Clouds":
           mainImageView.image = Constants.cloudIcon()
           
       case "Thunder":
           mainImageView.image = Constants.thunderIcon()
           
       default:
           mainImageView.image = Constants.sunIcon()
       }
       
       timeLabel.text = "\(model.dateTime.suffix(8).prefix(5))"
       tempLabel.text = "\(model.temp)°"
    }
}
