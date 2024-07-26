//
//  ViewController.swift
//  WeatherToday
//
//  Created by Арсений Варицкий on 20.07.24.
//

import UIKit
import RswiftResources
import SnapKit
import CoreLocation

protocol MainViewControllerInterface: AnyObject {}

class MainViewController: UIViewController {
    
    private enum Constants {
        static var sunnyImage = { R.image.sunnyImage() }
        static var rainyImage = { R.image.rainyImage() }
        static var snowImage = { R.image.snowImage() }
        static var eveningImage = { R.image.eveningImage() }
        static var nightImage = { R.image.nightImage() }
        static var pinImage = { R.image.pinImage() }
        static var hourCellIdentifier = { "hourCellIdentifier" }
        static var dailyCellIdentifier = { "dailyCellIdentifier" }
    }
    
    private var viewModel: MainViewModel
    
    private let locationManager = CLLocationManager()
    
    private let currentWeatherService = CurrentWeatherService()
    private let hourWeatherService = HourWeatherService()
    private let dailyWeatherService = DailyWeatherService()
    
    private var currentLatitude: String?
    private var currentLongitude: String?
    
    private var currentWeatherModel: CurrentWeatherModel?
    private var hourWeatherModels: [HourWeatherModel]?
    private var dailyWeatherModels: [DailyWeatherModel]?
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var currentTempLabel: UILabel = {
        let label = UILabel()
        label.text = "--°C"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 45)
        return label
    }()
    
    private lazy var maxTempLabel: UILabel = {
        let label = UILabel()
        label.text = "H: --"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var minTempLabel: UILabel = {
        let label = UILabel()
        label.text = "L: --"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var maxMinStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var tempStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.pinImage()
        return imageView
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Unknown"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var locationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let weatherCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        setupLocationManager()
        setBackground()
        setupCollectionView()
        maxMinStackView.addArrangedSubviews([maxTempLabel, minTempLabel])
        tempStackView.addArrangedSubviews([currentTempLabel, maxMinStackView])
        locationStackView.addArrangedSubviews([pinImageView, locationLabel])
        view.addSubviews([backgroundImageView, tempStackView, locationStackView, descriptionLabel, weatherCollection])
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tempStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(25)
        }
        
        locationStackView.snp.makeConstraints {
            $0.trailing.equalTo(tempStackView)
            $0.top.equalTo(tempStackView.snp.bottom).offset(12)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(25)
            $0.top.equalToSuperview().offset(view.bounds.height / 1.7)
        }
        
        weatherCollection.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    private func setupLocationManager() {
        self.locationManager.delegate = self
        
        let locQueue = DispatchQueue(label: "locQueue")
        
        locQueue.async { [self] in
            if CLLocationManager.locationServicesEnabled() {
                switch locationManager.authorizationStatus {
                case .authorizedWhenInUse, .authorizedAlways:
                    startLocationUpdates()
                    
                case .notDetermined:
                    DispatchQueue.main.async { [self] in
                        locationManager.requestWhenInUseAuthorization()
                        locationManager.requestAlwaysAuthorization()
                        startLocationUpdates()
                    }
                    
                case .restricted, .denied:
                    print("Location access was restricted or denied.")
                    showPermissionAlert()
                    
                @unknown default:
                    break
                }
            } else {
                print("Location services are not enabled.")
            }
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        weatherCollection.collectionViewLayout = layout
        weatherCollection.backgroundColor = .clear
        
        weatherCollection.register(HourWeatherCell.self, forCellWithReuseIdentifier: Constants.hourCellIdentifier())
        weatherCollection.register(DailyWeatherCell.self, forCellWithReuseIdentifier: Constants.dailyCellIdentifier())

        weatherCollection.dataSource = self
        weatherCollection.delegate = self
        weatherCollection.showsHorizontalScrollIndicator = false
        weatherCollection.isScrollEnabled = false
        weatherCollection.collectionViewLayout = createLayout()
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else  { return nil }
            switch sectionIndex {
            case 0:
                return self.createHourSection()
                
            case 1:
                return self.createDailySection()

            default:
                let defaultItemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let defaultItem = NSCollectionLayoutItem(layoutSize: defaultItemSize)
                let defaultGroup = NSCollectionLayoutGroup.horizontal(layoutSize: defaultItemSize, subitems: [defaultItem])
                return NSCollectionLayoutSection(group: defaultGroup)
            }
        }
    }
    
    private func createLayoutSection(
        group: NSCollectionLayoutGroup,
        behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior,
        interGroupSpacing: CGFloat,
        supplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem]
        
    ) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = behavior
        section.interGroupSpacing = interGroupSpacing
        section.boundarySupplementaryItems = supplementaryItems
        return section
    }
    
    private func createHourSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(22),
            heightDimension: .absolute(74)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = createLayoutSection(
            group: group,
            behavior: .continuousGroupLeadingBoundary,
            interGroupSpacing: 20,
            supplementaryItems: []
        )
        section.contentInsets = .init(top: .zero, leading: 30, bottom: .zero, trailing: .zero)
        return section
    }
    
    private func createDailySection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(view.bounds.width - 60),
            heightDimension: .absolute(30)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = createLayoutSection(
            group: group,
            behavior: .none,
            interGroupSpacing: 8,
            supplementaryItems: []
        )
        section.contentInsets = .init(top: 30, leading: 30, bottom: .zero, trailing: .zero)
        return section
    }
    
    private func showPermissionAlert() {
        let alertController = UIAlertController(
            title: "Location Permission error",
            message: "Please enable location services in your settings",
            preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        
        let cencelAction = UIAlertAction(title: "Cencel", style: .cancel)
        
        alertController.addAction(settingsAction)
        
        alertController.addAction(cencelAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    
    private func startLocationUpdates() {
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 1000
        locationManager.startUpdatingLocation()
    }
    
    private func setBackground() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        
        switch currentWeatherModel?.main {
        case "Rain", "Thunderstorm":
            backgroundImageView.image = Constants.rainyImage()
            
        case "Snow":
            backgroundImageView.image = Constants.snowImage()
            
        default:
            if let currentHour = Int(dateFormatter.string(from: currentDate)) {
                switch currentHour {
                case 5..<10:
                    backgroundImageView.image = Constants.eveningImage()
                    
                case 19..<22:
                    backgroundImageView.image = Constants.eveningImage()
                    
                case 22..<24, 0..<5:
                    backgroundImageView.image = Constants.nightImage()
                    
                default:
                    backgroundImageView.image = Constants.sunnyImage()
                }
            }
        }
    }
    
    private func getCurrentWeatherModel() {
        currentWeatherService.fetchWeather(lat: currentLatitude ?? "", lon: currentLongitude ?? "") { [weak self] weather in
            guard let self = self, let weather = weather else { return }
            self.currentWeatherModel = weather
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    private func getHourWeatherModel() {
        hourWeatherService.fetchWeather(lat: currentLatitude ?? "", lon: currentLongitude ?? "") { [weak self] weather in
            guard let self = self, let weather = weather else { return }
            self.hourWeatherModels = Array(weather.prefix(12))
            DispatchQueue.main.async {
                self.weatherCollection.reloadData()
            }
        }
    }
    
    private func getDailyWeatherModel() {
        dailyWeatherService.fetchWeather(lat: currentLatitude ?? "", lon: currentLongitude ?? "") { [weak self] weather in
            guard let self = self, let weather = weather else { return }
            self.dailyWeatherModels = weather
            DispatchQueue.main.async {
                self.weatherCollection.reloadData()
            }
        }
    }
    
    private func updateUI() {
        setBackground()
        if let currentWeather = currentWeatherModel {
            currentTempLabel.text = "\(currentWeather.currentTemp)°C"
            maxTempLabel.text = "H: \(currentWeather.maxTemp)°"
            minTempLabel.text = "L: \(currentWeather.minTemp)°"
            locationLabel.text = "\(currentWeather.city), \(currentWeather.country)"
            descriptionLabel.text = "\(currentWeather.description.capitalizingFirstLetter())"
        }
    }
}

extension MainViewController: MainViewControllerInterface {}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Current location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            
            currentLatitude = "\(location.coordinate.latitude)"
            currentLongitude = "\(location.coordinate.longitude)"
            getCurrentWeatherModel()
            getHourWeatherModel()
            getDailyWeatherModel()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error)")
    }
}

extension MainViewController: UICollectionViewDelegate {
    
}

extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            hourWeatherModels?.count ?? .zero
        case 1:
            dailyWeatherModels?.count ?? .zero
        default:
                .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Constants.hourCellIdentifier(),
                for: indexPath
            ) as? HourWeatherCell else {
                return UICollectionViewCell()
            }
            if let hourWeather = hourWeatherModels?[indexPath.item] {
                cell.configure(with: hourWeather)
            }
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Constants.dailyCellIdentifier(),
                for: indexPath
            ) as? DailyWeatherCell else {
                return UICollectionViewCell()
            }
            if let dailyWeather = dailyWeatherModels?[indexPath.item] {
                cell.configure(with: dailyWeather)
            }
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}
