//
//  PokemonDetailViewController.swift
//  Pokemon
//
//  Created by Miguel Martins on 10/05/2024.
//

import UIKit

// MARK: - PokemonDetailViewControllerType Definition
protocol PokemonDetailViewControllerType: AnyObject {
    
    var presenter: PokemonDetailPresenterType { get set }

    func onPokemonDetailViewController(on pokemonListPresenter: PokemonDetailPresenterType)
    func onPokemonDetailViewController(on pokemonListPresenter: PokemonDetailPresenterType, didChangeFavoriteStatusWith isFavorited: Bool)
}

// MARK: - PokemonDetailViewController

class PokemonDetailViewController: ViewController {
    
    // MARK: - Properties
    var presenter: PokemonDetailPresenterType
    
    private var pokemon: PokemonViewModel?
    
    private var contentWidth =  UIScreen.main.bounds.width
    private var contentHeight  = UIScreen.main.bounds.height
    
    // MARK: - Views
    
    private var scrollView: UIScrollView = {
        
        let scrollView = UIScrollView().usingAutoLayout()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isScrollEnabled = true
        scrollView.isDirectionalLockEnabled = true
        
        return scrollView
    }()
    
    private var scrollContentStackView: UIStackView = {
        
        let stackView = UIStackView().usingAutoLayout()
        stackView.backgroundColor = .clear
        stackView.contentMode = .center
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true

        return stackView
    }()
    
    private var topView: UIView = {
        
        let view = UIView().usingAutoLayout()
        view.backgroundColor = .clear
        view.contentMode = .center

        return view
    }()
    
    private var statsView: UIView = {
        
        let view = UIView().usingAutoLayout()
        view.backgroundColor = .white
        view.contentMode = .center
        view.layer.cornerRadius = PokemonConstants.Layout.defaultCornerRadius
        view.layer.masksToBounds = true

        return view
    }()
    
    private var favoriteButton: UIButton = {
        
        let button = UIButton().usingAutoLayout()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.accent.cgColor
        button.backgroundColor = .white
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private var pokemonImageView: AsyncImageView = {
        
        let imageView = AsyncImageView().usingAutoLayout()
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()
    
    private var titleLabel: UILabel = {
       
        let titleLabel = UILabel().usingAutoLayout()
        titleLabel.font = UIFont.pokemonBoldText
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        return titleLabel
    }()
    
    private var mainStatsStackView: UIStackView = {
        
        let stackView = UIStackView().usingAutoLayout()
        stackView.backgroundColor = .clear
        stackView.contentMode = .center
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually

        return stackView
    }()
    
    private var hpStatStackView: StatStackView = StatStackView(statLabelText: "Hp").usingAutoLayout()
    private var weightStatStackView: StatStackView = StatStackView(statLabelText: "Weight").usingAutoLayout()
    private var heightStatStackView: StatStackView = StatStackView(statLabelText: "Height").usingAutoLayout()
    private var typeStatStackView: StatStackView = StatStackView(statLabelText: "Type").usingAutoLayout()

    private var slidersStackView: UIStackView = {
        
        let stackView = UIStackView().usingAutoLayout()
        stackView.backgroundColor = .clear
        stackView.contentMode = .center
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fillEqually

        return stackView
    }()
    
    private var speedLabel: UILabel = {
       
        let titleLabel = UILabel().usingAutoLayout()
        titleLabel.font = UIFont.pokemonBoldText
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.text = "Speed"

        return titleLabel
    }()
    
    private var speedSlider: PokemonStatSliderView = PokemonStatSliderView().usingAutoLayout()
    
    private var attackLabel: UILabel = {
       
        let titleLabel = UILabel().usingAutoLayout()
        titleLabel.font = UIFont.pokemonBoldText
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.text = "Attack"

        return titleLabel
    }()

    private var attackSlider: PokemonStatSliderView = PokemonStatSliderView().usingAutoLayout()
    
    private var defenseLabel: UILabel = {
       
        let titleLabel = UILabel().usingAutoLayout()
        titleLabel.font = UIFont.pokemonBoldText
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.text = "Defense"

        return titleLabel
    }()
    
    private var defenseSlider: PokemonStatSliderView = PokemonStatSliderView().usingAutoLayout()

    
    // MARK: - Initializer
    init(presenter: PokemonDetailPresenterType) {
        
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }
  
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("PokemonDetailViewController: viewDidLoad")
        
        self.presenter.onPokemonDetailPresenter(on: self)
    }
    
    override func configureView() {
                
        self.view.backgroundColor = UIColor(named: "BackgroundColor")
        self.navigationItem.setHidesBackButton(false, animated: true)
        self.favoriteButton.addTarget(self, action: #selector(self.changeFavoriteStatus), for: .touchUpInside)
    }
    
    @objc func changeFavoriteStatus() {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        self.presenter.onPokemonDetailPresenterDidChangeFavoriteStatus(on: self)
    }
    
    override func addSubviews() {

        self.topView.addSubview(self.favoriteButton)
        self.topView.addSubview(self.pokemonImageView)
        
        self.mainStatsStackView.addArrangedSubviews([self.hpStatStackView, self.weightStatStackView, self.heightStatStackView])
        
        self.statsView.addSubview(self.titleLabel)
        self.statsView.addSubview(self.typeStatStackView)
        self.statsView.addSubview(self.mainStatsStackView)
        
        self.slidersStackView.addArrangedSubviews([self.speedLabel, self.speedSlider, self.attackLabel, self.attackSlider, self.defenseLabel, self.defenseSlider])
        self.statsView.addSubview(self.slidersStackView)
        
        self.scrollContentStackView.addArrangedSubviews([self.topView, self.statsView])
        
        self.scrollView.addSubview(self.scrollContentStackView)
        self.view.addSubview(self.scrollView)
    }
    
    override func defineConstraints() {
        
        // MARK: - Scroll View Constraints
        
        NSLayoutConstraint.activate([
            
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // MARK: - ScrollContentStackView Constraints
        
        NSLayoutConstraint.activate([

            self.scrollContentStackView.topAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.topAnchor),
            self.scrollContentStackView.leadingAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.leadingAnchor),
            self.scrollContentStackView.trailingAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.trailingAnchor),
            self.scrollContentStackView.bottomAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.bottomAnchor),
            self.scrollContentStackView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor),
            self.scrollContentStackView.heightAnchor.constraint(equalToConstant: self.scrollView.safeAreaLayoutGuide.layoutFrame.height)
         ])

        // MARK: - PokemonImageView constraints
        
        NSLayoutConstraint.activate([
            
            self.pokemonImageView.topAnchor.constraint(equalTo: self.topView.topAnchor, constant: 16),
            self.pokemonImageView.centerXAnchor.constraint(equalTo: self.topView.centerXAnchor),
            self.pokemonImageView.bottomAnchor.constraint(equalTo: self.topView.bottomAnchor),
            self.pokemonImageView.heightAnchor.constraint(equalToConstant: 200),
            self.pokemonImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
                
        // MARK: - FavoriteButton constraints
        
        NSLayoutConstraint.activate([
            
            self.favoriteButton.topAnchor.constraint(equalTo: self.topView.topAnchor, constant: 8),
            self.favoriteButton.trailingAnchor.constraint(equalTo: self.topView.trailingAnchor),
            self.favoriteButton.heightAnchor.constraint(equalToConstant: 32),
            self.favoriteButton.widthAnchor.constraint(equalToConstant: 32)
        ])
            
        // MARK: - TitleLabel constraints

        NSLayoutConstraint.activate([
            
            self.titleLabel.topAnchor.constraint(equalTo: self.statsView.topAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.statsView.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.statsView.trailingAnchor),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        // MARK: - TypeStackView constraints
        
        NSLayoutConstraint.activate([
            
            self.typeStatStackView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 8),
            self.typeStatStackView.leadingAnchor.constraint(equalTo: self.statsView.leadingAnchor, constant: 32),
            self.typeStatStackView.trailingAnchor.constraint(equalTo: self.statsView.trailingAnchor, constant: -32)
        ])
        
        // MARK: - MainStackView constraints
        
        NSLayoutConstraint.activate([
            
            self.mainStatsStackView.topAnchor.constraint(equalTo: self.typeStatStackView.bottomAnchor, constant: 32),
            self.mainStatsStackView.leadingAnchor.constraint(equalTo: self.statsView.leadingAnchor, constant: 32),
            self.mainStatsStackView.trailingAnchor.constraint(equalTo: self.statsView.trailingAnchor, constant: -32)
        ])
        
        // MARK: - SlidersStackView constraints
        
        NSLayoutConstraint.activate([
            
            self.slidersStackView.topAnchor.constraint(equalTo: self.mainStatsStackView.bottomAnchor, constant: 32),
            self.slidersStackView.leadingAnchor.constraint(equalTo: self.statsView.leadingAnchor, constant: 32),
            self.slidersStackView.trailingAnchor.constraint(equalTo: self.statsView.trailingAnchor, constant: -32)
        ])
    }
}

// MARK: - PokemonDetailViewControllerType implementation

extension PokemonDetailViewController: PokemonDetailViewControllerType {
    
    func onPokemonDetailViewController(on pokemonListPresenter: any PokemonDetailPresenterType) {
        
        guard let pokemon = self.presenter.pokemon else { return }
        
        self.pokemon = pokemon
        
        Task { @MainActor in
            
            self.title = pokemon.name
            self.titleLabel.text = pokemon.name
            self.hpStatStackView.configure(with: String(pokemon.hp))
            self.weightStatStackView.configure(with: String(pokemon.weight))
            self.heightStatStackView.configure(with:  String(pokemon.height))
            self.typeStatStackView.configure(with: pokemon.pokemonTypes)
            
            self.speedSlider.configure(statValue: Float(pokemon.speed), minimumValueImageName: "timer.circle", maximumValueImageName: "timer.circle.fill")
            self.attackSlider.configure(statValue: Float(pokemon.attack), minimumValueImageName: "dumbbell", maximumValueImageName: "dumbbell.fill")
            self.defenseSlider.configure(statValue: Float(pokemon.defense), minimumValueImageName: "shield", maximumValueImageName: "shield.fill")
            
            self.configureFavoriteButton(isFavorited: pokemon.isFavorited)
            self.configureImageView(with: pokemon)
        }
    }
    
    func onPokemonDetailViewController(on pokemonListPresenter: any PokemonDetailPresenterType, didChangeFavoriteStatusWith isFavorited: Bool) {
        
        Task { @MainActor in
            
            self.configureFavoriteButton(isFavorited: isFavorited)
        }
    }
}

// MARK: - Private Methods

private extension PokemonDetailViewController {
    
    func configureFavoriteButton(isFavorited: Bool) {
        
        let buttonImage = isFavorited ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        self.favoriteButton.setImage(buttonImage, for: .normal)
    }
    
    func configureImageView(with viewModel: PokemonViewModel) {

        guard let image = viewModel.image else {
            
            if let pokemonImage = UIImage(named: "PokemonLogo") {
                
                self.pokemonImageView.setImage(image: pokemonImage)
            }
            
            return
        }
        
        self.pokemonImageView.setImage(image: image)
    }
}
