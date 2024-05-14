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
    
    var tasksDictionary: [String: Task<Void, Never>?] = [:]
    
    // MARK: - Views
    
    private var backgroundView: UIView = {
        
        let view = UIView().usingAutoLayout()
        view.backgroundColor = .white
        view.layer.cornerRadius = PokemonConstants.Layout.defaultCornerRadius

        return view
    }()
    
    private var loaderView: PokemonLoader = PokemonLoader().usingAutoLayout()
    
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
        
        let placeholder = PokemonConstants.PokemonListScreen.placeholderText
        
        let attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        
        searchController.searchBar.searchTextField.attributedPlaceholder = attributedPlaceholder
        
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
        collectionView.layer.shadowPath = UIBezierPath(rect: collectionView.bounds).cgPath
        collectionView.accessibilityIdentifier = PokemonConstants.PokemonListScreen.AccessibilityIdentifiers.pokemonCollectionView
        
        collectionView.register(PokemonCellView.self,forCellWithReuseIdentifier: PokemonCellView.identifier)
        
        collectionView.isHidden = true
        
        return collectionView
    }()
    
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
        
        self.screenStatus(shouldShowLoader: true)
    }
    
    override func configureView() {
        
        self.title = PokemonConstants.PokemonListScreen.title
        self.view.backgroundColor = UIColor(named: "BackgroundColor")
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        self.navigationItem.searchController = self.searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.pokemonCollectionView.dataSource = self
        self.pokemonCollectionView.delegate = self

        let searchBar = self.searchController.searchBar
        searchBar.delegate = self
    }
    
    override func addSubviews() {
        
        self.backgroundView.addSubview(self.loaderView)
        self.view.addSubview(self.backgroundView)
        self.view.addSubview(self.pokemonCollectionView)
    }
    
    override func defineConstraints() {
        
        // MARK: - BackgroundView
        
        NSLayoutConstraint.activate([
            
            self.backgroundView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                                                            constant: PokemonConstants.Layout.defaultLeadingDistance),
            self.backgroundView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
                                                                constant: PokemonConstants.Layout.defaultLeadingDistance),
            self.backgroundView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
                                                                 constant: PokemonConstants.Layout.defaultTrailingDistance),
            self.backgroundView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                                               constant: PokemonConstants.Layout.defaultTrailingDistance)
        ])
        
        // MARK: - LoaderView constraints
        
        NSLayoutConstraint.activate([
        
            self.loaderView.centerXAnchor.constraint(equalTo: self.backgroundView.centerXAnchor),
            self.loaderView.centerYAnchor.constraint(equalTo: self.backgroundView.centerYAnchor),
            self.loaderView.heightAnchor.constraint(equalToConstant: 48),
            self.loaderView.widthAnchor.constraint(equalToConstant: 48)
        ])
        
        // MARK: - PokemonCollectionView constraints
        
        NSLayoutConstraint.activate([
            
            self.pokemonCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, 
                                                            constant: PokemonConstants.Layout.defaultLeadingDistance),
            self.pokemonCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, 
                                                                constant: PokemonConstants.Layout.defaultLeadingDistance),
            self.pokemonCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, 
                                                                 constant: PokemonConstants.Layout.defaultTrailingDistance),
            self.pokemonCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, 
                                                               constant: PokemonConstants.Layout.defaultTrailingDistance)
        ])
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        
        self.pokemonCollectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - PokemonListViewControllerType implementation

extension PokemonListViewController: PokemonListViewControllerType {
    
    func onFetchPokemons(on: any PokemonListPresenterType, with pokemons: [Pokemon]) {

        self.screenStatus(shouldShowLoader: false)
        self.pokemonCollectionView.reloadData()
    }
}

// MARK: - Private Methods

private extension PokemonListViewController {
    
    func screenStatus(shouldShowLoader: Bool) {
        
        if shouldShowLoader {
            
            self.loaderView.startAnimation()
            self.loaderView.isHidden = false
            self.backgroundView.isHidden = false
            self.pokemonCollectionView.isHidden = true
            
        } else {
            
            self.loaderView.stopAnimation()
            self.loaderView.isHidden = true
            self.backgroundView.isHidden = true
            self.pokemonCollectionView.isHidden = false
        }
    }
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
        
        let task = Task { @MainActor in

            let pokemonViewModel = PokemonViewModelFactory.createPokemonViewModel(from: pokemon)
            
            cell.delegate = self
            await cell.configure(with: pokemonViewModel)
        }
        
        self.tasksDictionary[pokemon.name] = task
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCellView.identifier, for: indexPath) as? PokemonCellView else {
            
            return
        }
        
        let pokemon = self.presenter.pokemons[indexPath.row]
        
        // Cancelling fetching of images on pokemon cell ensuring smoother srolling
        self.tasksDictionary[pokemon.name]??.cancel()
    }
}

// MARK: - UICollectionViewDelegate implementation

extension PokemonListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let pokemon = self.presenter.pokemons[indexPath.row]
        let pokemonViewModel = PokemonViewModelFactory.createPokemonViewModel(from: pokemon)
        
        self.presenter.onPokemonListPresenter(on: self, pokemonCellTappedWith: pokemonViewModel)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout implementation

extension PokemonListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.orientation.isLandscape  {
            
            let widthFrame = self.view.frame.width / PokemonConstants.PokemonListScreen.landscapeWidthDivisor
            let heightFrame = self.view.frame.height / PokemonConstants.PokemonListScreen.landscapeHeightDivisor
            
            return CGSize(width: widthFrame, height: heightFrame)

       } else {

           let widthFrame = self.view.frame.width / PokemonConstants.PokemonListScreen.portraitWidthDivisor
           let heightFrame = self.view.frame.height / PokemonConstants.PokemonListScreen.portraitHeightDivisor
           
           return CGSize(width: widthFrame, height: heightFrame)
       }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return PokemonConstants.PokemonListScreen.collectionViewLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let inset = PokemonConstants.PokemonListScreen.collectionViewInsets
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let height = scrollView.contentSize.height
        
        let screenHeight = scrollView.frame.size.height
        let speedFactor: CGFloat = 300

        if offsetY >= height -  screenHeight - speedFactor  {
            
            print("Fetching another page")
            self.presenter.fetchNextPokemonsOnPokemonListPresenter(on: self)
        }
    }
}

// MARK: - UISearchResultsUpdating implementation

extension PokemonListViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        let searchText = searchController.searchBar.text
        print(searchText ?? "")
        
        if let searchText,
            searchText.isEmpty == false {
            
            self.presenter.onPokemonListPresenter(on: self, userSearchedForText: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.presenter.onPokemonListPresenter(on: self, userSearchedForText: "")
    }
}

// MARK: - PokemonCellViewDelegate

extension PokemonListViewController: PokemonCellViewDelegate {
    
    func didTapFavoriteButton(with pokemonViewModel: PokemonViewModel) {
        
        self.presenter.onPokemonListPresenter(on: self, userTappedFavoriteButtonWith: pokemonViewModel)
    }
}
