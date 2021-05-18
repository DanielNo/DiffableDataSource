//
//  ViewController.swift
//
//  Created by Daniel No on 4/12/20.
//  Copyright © 2020 Daniel No. All rights reserved.
//

import UIKit
import CoreData
class HomeViewController: UIViewController {
    
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "PokemonTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "pokemonCell")
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getMoreData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.delegate = self
        return tableView
    }()
    
    var pokemonData : Set<String> = ["bulbasaur","ivysaur","venusaur","charmander","charmeleon","charizard","squirtle","wartortle","blastoise","caterpie","metapod","butterfree","weedle","kakuna","beedrill","pidgey","pidgeotto","pidgeot","rattata","raticate","spearow","fearow","ekans","arbok","pikachu","raichu","mewtwo","mew"]
    var pokemonArray : [String] {
        return Array(pokemonData).sorted()
    }
        
    // Diffable Data Source
    enum Section{
        case main
    }
    
    private lazy var dataSource : UITableViewDiffableDataSource<Section,String> = {
        let datasource : UITableViewDiffableDataSource<Section,String> = UITableViewDiffableDataSource(tableView: self.tableView) { [unowned self](tableview, indexpath, pokemonName) -> UITableViewCell? in
            let cell = tableview.dequeueReusableCell(withIdentifier: "pokemonCell", for: indexpath) as? PokemonTableViewCell
            cell?.textLabel?.text = pokemonName
            return cell
        }
        return datasource
    }()
    private var sections = [Section.main]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func setupUI(){
        self.title = "Pokedex"
        self.view.addSubview(tableView)
        let constraints = [tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                           tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                           tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                           tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)]
        NSLayoutConstraint.activate(constraints)
        self.definesPresentationContext = true
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for pokemon"
        navigationItem.searchController = searchController
        applyInitialSnapshot(animatingDifferences: false)
    }
    
    @objc func getMoreData(){
        var newData : Set<String> = Set(arrayLiteral: "eevee","jolteon","flareon","vaporeon")
        
        // Make a snapshot and apply it with all items you want to include, or insert into the existing snapshot by calling .snapshot() on the currently used datasource.
       var snapshot = NSDiffableDataSourceSnapshot<Section,String>()
        snapshot.appendSections([.main])
        pokemonData = pokemonData.union(newData)
        snapshot.appendItems(pokemonArray)
        dataSource.apply(snapshot,animatingDifferences: true)
        tableView.refreshControl?.endRefreshing()
    }
    
    
}

extension HomeViewController{
    
    func applyInitialSnapshot(animatingDifferences: Bool = true) {
      var snapshot = NSDiffableDataSourceSnapshot<Section,String>()
      snapshot.appendSections(sections)
      snapshot.appendItems(pokemonArray)
      dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    
}

extension HomeViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let poke = self.pokemonArray[indexPath.row]
        print(poke)
    }
    
}

extension HomeViewController : UISearchResultsUpdating,UISearchControllerDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text.count > 0 else{
            applyInitialSnapshot()
            return
        }
        let filteredPokemonData = pokemonArray.filter({ (name) -> Bool in
            name.contains(text.lowercased())
        })
        print(filteredPokemonData)
        
        // Create a new snapshot and use filtered search results to populate it, leave the original data source set/array unmodified
        var snapshot = NSDiffableDataSourceSnapshot<Section,String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(filteredPokemonData)
        dataSource.apply(snapshot)
    }
    
    
    
}
extension HomeViewController : UISearchBarDelegate{
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
//    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
//
//    }
//
//    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//
//    }
}

