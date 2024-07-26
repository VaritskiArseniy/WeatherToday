//
//  DailyWeatherCell.swift
//  WeatherToday
//
//  Created by Арсений Варицкий on 25.07.24.
//

import UIKit

class DailyWeatherCell: UICollectionViewCell {
    
    private enum Constants {
        static var sunIcon = { R.image.sunIcon() }
        static var cloudIcon = { R.image.cloudIcon() }
        static var rainIcon = { R.image.rainIcon() }
        static var snowIcon = { R.image.snowIcon() }
    }
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()
    
    private lazy var maxTempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()  
    
    private lazy var minTempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
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
            dateLabel,
            mainImageView,
            maxTempLabel,
            minTempLabel
        ])
    }
    
    private func setupConstraints() {
        dateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        mainImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.width.equalTo(22)
        }
        
        minTempLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        maxTempLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(minTempLabel).inset(30)
        }
    }
    
   func configure(with model: DailyWeatherModel) {
       
       let weatherType = WeatherTypes.weatherType(for: model.code)
       
       switch weatherType {
       case .sun:
           mainImageView.image = Constants.sunIcon()
       case .clouds:
           mainImageView.image = Constants.cloudIcon()
       case .rain:
           mainImageView.image = Constants.rainIcon()
       case .snow:
           mainImageView.image = Constants.snowIcon()
       }
       
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-MM-dd"

       guard let date = dateFormatter.date(from: model.date) else { return }
       
       dateFormatter.dateFormat = "EEEE"
       let currentDateString: String = dateFormatter.string(from: date)
       
       dateLabel.text = "\(currentDateString)"
       minTempLabel.text = "\(model.minTemp)°"
       maxTempLabel.text = "\(model.maxTemp)°"
    }
}
