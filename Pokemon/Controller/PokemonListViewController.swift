//
//  PokemonListViewController.swift
//  Pokedex
//
//  Created by Jaafar Barek on 21/10/2024.
//

import UIKit

class PokemonListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pokemonList: [PokemonResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let nib = UINib(nibName: "PokemonCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "PokemonCollectionViewCell")
        
        getPokemonsFromServer()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCollectionViewCell", for: indexPath) as! PokemonCollectionViewCell
        
        let pokemon = pokemonList[indexPath.item]
        
        cell.pokemonNameLabel.text = pokemon.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 190, height: 190)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPokemon = pokemonList[indexPath.item]
        
        if let pokemonURL = URL(string: selectedPokemon.url),
           let pokemonId = Int(pokemonURL.lastPathComponent) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailVC = storyboard.instantiateViewController(withIdentifier: "PokemonDetailsViewController") as? PokemonDetailsViewController {
                detailVC.pokemonId = pokemonId
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    
    func getPokemonsFromServer() {
        
        let urlString = "https://pokeapi.co/api/v2/pokemon"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data found")
                return
            }
            
            do {
                let pokemonResponse = try JSONDecoder().decode(PokemonResponse.self, from: data)
                
                self.pokemonList = pokemonResponse.results
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("Error couldn't retreive data")
            }
        }.resume()
    }
}
