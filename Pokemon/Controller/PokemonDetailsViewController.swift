import UIKit

class PokemonDetailsViewController: UIViewController {
    
    var pokemonId: Int?
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonHeightLabel: UILabel!
    @IBOutlet weak var pokemonWeightLabel: UILabel!
    @IBOutlet weak var pokemonBaseExperienceLabel: UILabel!
    @IBOutlet weak var pokemonAbilitiesLabel: UILabel!
    @IBOutlet weak var pokemonTypesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = pokemonId {
            fetchPokemonDetails(pokemonId: id)
            getPokemonColor(pokemonId: id)
        }
        navigationController?.navigationBar.tintColor = .white
    }
    
    func fetchPokemonDetails(pokemonId: Int) {
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(pokemonId)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data found")
                return
            }
            
            do {
                let pokemonDetail = try JSONDecoder().decode(PokemonDetail.self, from: data)
                
                DispatchQueue.main.async {
                    self.navigationItem.title = pokemonDetail.name.capitalized
                    self.pokemonHeightLabel.text = "Height: \(pokemonDetail.height) m"
                    self.pokemonWeightLabel.text = "Weight: \(pokemonDetail.weight) kg"
                    self.pokemonBaseExperienceLabel.text = "Base XP: \(pokemonDetail.base_experience)"
                    
                    let abilities = pokemonDetail.abilities.map { $0.ability.name.capitalized }.joined(separator: ", ")
                    self.pokemonAbilitiesLabel.text = "Abilities: \(abilities)"
                    
                    let types = pokemonDetail.types.map { $0.type.name.capitalized }.joined(separator: ", ")
                    self.pokemonTypesLabel.text = "Types: \(types)"
                    
                    if let imageUrl = URL(string: pokemonDetail.sprites.front_default ?? "") {
                        self.loadImage(from: imageUrl)
                    }
                }
            } catch {
                print("Error decoding data")
            }
        }.resume()
    }
    
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.pokemonImageView.image = image
                }
            } else {
                print("Failed to load image from url: \(url)")
            }
        }.resume()
    }
    
    func getPokemonColor(pokemonId: Int) {
        let urlString = "https://pokeapi.co/api/v2/pokemon-species/\(pokemonId)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data found")
                return
            }
            
            do {
                let speciesData = try JSONDecoder().decode(PokemonSpecies.self, from: data)
                let colorName = speciesData.color.name
                
                DispatchQueue.main.async {
                    self.backgroundView.backgroundColor = self.colorForPokemon(named: colorName)
                }
            } catch {
                print("Error decoding species data")
            }
        }.resume()
    }
    
    func colorForPokemon(named colorName: String) -> UIColor {
        switch colorName.lowercased() {
        case "green":
            return UIColor.green
        case "red":
            return UIColor.red
        case "blue":
            return UIColor.blue
        case "yellow":
            return UIColor.yellow
        case "brown":
            return UIColor.brown
        case "purple":
            return UIColor.purple
        case "pink":
            return UIColor.systemPink
        case "black":
            return UIColor.black
        case "gray":
            return UIColor.gray
        case "white":
            return UIColor.white
        default:
            return UIColor.gray
        }
    }
}
