//
//  PokemonListViewController.swift
//  Marvel
//
//  Created by Miguel Martins on 08/05/2024.
//

import UIKit

// MARK: - PokemonListViewControllerType Definition
protocol PokemonListViewControllerType: AnyObject {
    
    var presenter: PokemonListPresenterType { get set }
    func onFetchPokemons(on: PokemonListPresenterType, with pokemons: [Pokemon])
}

// MARK: - PokemonListViewController

class PokemonListViewController: ViewController {
    
    // MARK: - Properties
    var presenter: PokemonListPresenterType
    
    private var pokemons: [Pokemon] = []
    
    // MARK: - Views
    
    private var backgroundView: UIView = {
        
        let view = UIView().usingAutoLayout()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10

        return view
    }()
    
    private lazy var searchController: UISearchController = {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.backgroundColor = UIColor(named: "BackgroundColor")!
        searchController.searchBar.searchTextField.leftView?.tintColor = .accent
               
        let font = UIFont.pokemonCaptionText
        
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        let attributedText = NSAttributedString(string: "", attributes: attributes)
        
        searchController.searchBar.searchTextField.attributedText = attributedText
        
        let placeholder = "Search for Pokémon"
        
        let attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        
        searchController.searchBar.searchTextField.attributedPlaceholder = attributedPlaceholder
//        searchController.searchBar.showsCancelButton = true
//        searchController.searchBar.barTintColor = .black
        
        return searchController
    }()
    
    private lazy var pokemonCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = .zero
        layout.minimumInteritemSpacing = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).usingAutoLayout()
        
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.layer.cornerRadius = 10
        collectionView.layer.shadowColor = UIColor.black.cgColor
        collectionView.layer.shadowRadius = 1
        collectionView.layer.shadowOpacity = 0.2
        collectionView.layer.shadowOffset = .zero
        collectionView.bounces = false
        collectionView.accessibilityIdentifier = PokemonConstants.PokemonListScreen.AccessibilityIdentifiers.pokemonCollectionView
        
        collectionView.register(PokemonCellView.self,forCellWithReuseIdentifier: PokemonCellView.identifier)
        
        return collectionView
    }()
    
//    private lazy var logoImageView: UIImageView = {
//        
//        let image = UIImage(named: "Logo")
//        
//        let imageView = UIImageView(image: image).usingAutoLayout()
//        imageView.contentMode = .scaleAspectFit
//        imageView.layer.cornerRadius = 10
//        imageView.layer.masksToBounds = true
//        
//        return imageView
//    }()    
//    private let loginButton = MarvelButton().usingAutoLayout()
//
//    private var registrationButton = MarvelButton().usingAutoLayout()
    
    private lazy var buttonsStackView: UIStackView = {
        
        let stackView = UIStackView().usingAutoLayout()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        
        return stackView
    }()
    
    // MARK: - Initializer
    init(presenter: PokemonListPresenterType = PokemonListPresenter()) {
        
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }
  
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("PokemonListViewController: viewDidLoad")
        
        self.presenter.onPokemonListPresenter(on: self)
    }
    
    override func configureView() {
        
        self.title = "Pokémon"
        self.view.backgroundColor = UIColor.accent
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        self.navigationItem.searchController = self.searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.pokemonCollectionView.dataSource = self
        self.pokemonCollectionView.delegate = self
        self.searchController.searchResultsUpdater = self
        
//        self.loginButton.configure(with: .init(labelText: "Login", accessibilityIdentifier: "LoginButton"))
//        self.loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
//        
//        self.registrationButton.configure(with: .init(labelText: "Register", accessibilityIdentifier: "RegistrationButton"))
//        self.registrationButton.addTarget(self, action: #selector(didTapRegistrationButton), for: .touchUpInside)
    }
    
    override func addSubviews() {
        
//        self.backgroundView.addSubview(self.logoImageView)
        
        
        self.view.addSubview(self.pokemonCollectionView)
        
//        self.buttonsStackView.addArrangedSubviews([
//            self.loginButton,
//            self.registrationButton
//        ])
        
//        self.view.addSubview(self.logoImageView)
//        self.view.addSubview(self.buttonsStackView)
    }
    
    override func defineConstraints() {
        
        NSLayoutConstraint.activate([
            
//            self.logoImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
//            self.logoImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//            self.logoImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
//            self.logoImageView.heightAnchor.constraint(equalToConstant: 100),
//            self.logoImageView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            
            
//            self.backgroundView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
//            self.backgroundView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//            self.backgroundView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
//            self.backgroundView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor, constant: -16),
            
            
            
//            self.buttonsStackView.topAnchor.constraint(equalTo: self.backgroundView.centerYAnchor, constant: 64),
//            self.buttonsStackView.leadingAnchor.constraint(equalTo: self.backgroundView.leadingAnchor, constant: 16),
//            self.buttonsStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            
//            self.loginButton.leadingAnchor.constraint(equalTo: self.buttonsStackView.leadingAnchor),
//            self.loginButton.trailingAnchor.constraint(equalTo: self.buttonsStackView.trailingAnchor),
//            self.loginButton.heightAnchor.constraint(equalToConstant: 50),
//            
//            self.registrationButton.leadingAnchor.constraint(equalTo: self.buttonsStackView.leadingAnchor),
//            self.registrationButton.trailingAnchor.constraint(equalTo: self.buttonsStackView.trailingAnchor),
//            self.registrationButton.heightAnchor.constraint(equalToConstant: 50)
            
            self.pokemonCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: PokemonConstants.Layout.defaultLeadingDistance),
            self.pokemonCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: PokemonConstants.Layout.defaultLeadingDistance),
            self.pokemonCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: PokemonConstants.Layout.defaultTrailingDistance),
            self.pokemonCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: PokemonConstants.Layout.defaultTrailingDistance)
        ])
    }
}

// MARK: - PokemonListViewControllerType implementation

extension PokemonListViewController: PokemonListViewControllerType {
    
    func onFetchPokemons(on: any PokemonListPresenterType, with pokemons: [Pokemon]) {
        
        self.pokemons = pokemons
        self.pokemonCollectionView.reloadData()
    }
}

// MARK: - Button Methods

private extension PokemonListViewController {
    
}

// MARK: - UICollectionViewDataSource implementation

extension PokemonListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        self.presenter.pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCellView.identifier, for: indexPath) as? PokemonCellView else {
            
            return UICollectionViewCell()
        }
        
        let pokemon = self.presenter.pokemons[indexPath.row]
        let officialArtwork = pokemon.sprites.otherSprites.officialArtwork
        
        Task { @MainActor in
            
            await cell.configure(with: .init(imageUrl: officialArtwork.frontDefault, name: pokemon.name.capitalized))
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate implementation

extension PokemonListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let pokemon = self.presenter.pokemons[indexPath.row]
        
        let pokemonViewModel = PokemonViewModel(
            imageUrl: pokemon.sprites.otherSprites.officialArtwork.frontDefault,
            name: pokemon.name.capitalized
        )
        
        self.presenter.onPokemonListPresenter(on: self, pokemonCellTappedWith: pokemonViewModel)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout implementation

extension PokemonListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.orientation.isLandscape  {
            
            let widthFrame = (self.view.frame.width / 5)
            let heightFrame = (self.view.frame.height / 2)
            
            return CGSize(width: widthFrame, height: heightFrame)
            
            
       } else if UIDevice.current.orientation.isPortrait {
           
           
           let widthFrame = (self.view.frame.width / 3)
           let heightFrame = (self.view.frame.height / 5)
           
           return CGSize(width: widthFrame, height: heightFrame)
           
       } else {
           
           let widthFrame = (self.view.frame.width / 3)
           let heightFrame = (self.view.frame.height / 5)
           
           return CGSize(width: widthFrame, height: heightFrame)
       }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
//        let width = scrollView.frame.width
        //        self.currentPage = Int(scrollView.contentOffset.x / width)
        //        self.pageControl.currentPage = self.currentPage
    }

    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        
        self.pokemonCollectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - UISearchResultsUpdating implementation

extension PokemonListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        print("\(searchController.searchBar.text ?? "")")
    }
}
