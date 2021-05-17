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
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var pokemonData = ["bulbasaur","ivysaur","venusaur","charmander","charmeleon","charizard","squirtle","wartortle","blastoise","caterpie","metapod","butterfree","weedle","kakuna","beedrill","pidgey","pidgeotto","pidgeot","rattata","raticate","spearow","fearow","ekans","arbok","pikachu","raichu","mewtwo","mew"]
    
    var filteredPokemonData : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredPokemonData = pokemonData
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
        
    }
    
    
}

extension HomeViewController : UISearchResultsUpdating,UISearchControllerDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text.count > 0 else{
            filteredPokemonData = pokemonData
            return
        }
        filteredPokemonData = pokemonData.filter({ (name) -> Bool in
            name.contains(text.lowercased())
        })
print(filteredPokemonData)
        self.tableView.reloadData()
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

extension HomeViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPokemonData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuse")
        cell.backgroundColor = .white
        cell.textLabel?.text = filteredPokemonData[indexPath.row]
        return cell
    }
    
    // Because we are using NSFetchedResultsController, grab the model object from the fetched results controller instead of managing it ourselves.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    
    
}
