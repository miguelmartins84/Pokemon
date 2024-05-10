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
    func onPokemonDetailViewControllerStart()
}

// MARK: - PokemonDetailViewController

class PokemonDetailViewController: ViewController {
    
    // MARK: - Properties
    var presenter: PokemonDetailPresenterType
    
    private var pokemon: PokemonViewModel?
    
    // MARK: - Views
    
    private var backgroundView: UIView = {
        
        let view = UIView().usingAutoLayout()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10

        return view
    }()
    
    private var headerStackView: UIStackView = {
        
        let stackView = UIStackView().usingAutoLayout()
        stackView.axis = .horizontal
        stackView.alignment = .top

        return stackView
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
        
        return titleLabel
    }()
    
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
        
//        self.loginButton.configure(with: .init(labelText: "Login", accessibilityIdentifier: "LoginButton"))
//        self.loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
//
//        self.registrationButton.configure(with: .init(labelText: "Register", accessibilityIdentifier: "RegistrationButton"))
//        self.registrationButton.addTarget(self, action: #selector(didTapRegistrationButton), for: .touchUpInside)
    }
    
    override func addSubviews() {
        
        self.headerStackView.addArrangedSubviews([
            self.pokemonImageView,
            self.titleLabel
        ])
        
        self.view.addSubview(self.backgroundView)
        self.view.addSubview(self.headerStackView)
        
//        self.buttonsStackView.addArrangedSubviews([
//            self.loginButton,
//            self.registrationButton
//        ])
        
//        self.view.addSubview(self.logoImageView)
//        self.view.addSubview(self.buttonsStackView)
    }
    
    override func defineConstraints() {
        
        NSLayoutConstraint.activate([
            
            self.backgroundView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100),
            self.backgroundView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.backgroundView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.backgroundView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: PokemonConstants.Layout.defaultTrailingDistance),
            
            self.headerStackView.topAnchor.constraint(equalTo: self.backgroundView.topAnchor, constant: 8),
            self.headerStackView.leadingAnchor.constraint(equalTo: self.backgroundView.leadingAnchor),
            self.headerStackView.trailingAnchor.constraint(equalTo: self.backgroundView.trailingAnchor),
            
            self.pokemonImageView.widthAnchor.constraint(equalToConstant: 200),
            self.pokemonImageView.heightAnchor.constraint(equalToConstant: 200)
            
            
        ])
    }
}

// MARK: - PokemonDetailViewControllerType implementation

extension PokemonDetailViewController: PokemonDetailViewControllerType {
    
    func onPokemonDetailViewControllerStart() {
        
        guard let pokemon = self.presenter.pokemon else { return }
        
        self.title = pokemon.name
        
        self.titleLabel.text = pokemon.name
        self.pokemon = pokemon
        self.configureImageView(with: pokemon)
    }
}

// MARK: - Button Methods

private extension PokemonDetailViewController {
    
    func configureImageView(with viewModel: PokemonViewModel) {
        
        guard let imageURL = URL(string: viewModel.imageUrl) else { return }
        
        Task { @MainActor in
            
            await self.pokemonImageView.downloadImage(with: imageURL)
            self.pokemonImageView.image = self.pokemonImageView.image?.roundedCornerImage(with: PokemonConstants.Layout.defaultImageRoundedCornerRadius)
        }
    }
}
