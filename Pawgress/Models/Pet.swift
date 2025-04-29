import Foundation

struct Pet: Identifiable, Codable {
    let id: String
    var name: String
    var species: PetSpecies
    var currentPlanet: Planet
    var unlockedPostcards: [Postcard]
    
    init(id: String = UUID().uuidString, name: String, species: PetSpecies) {
        self.id = id
        self.name = name
        self.species = species
        self.currentPlanet = .earth
        self.unlockedPostcards = []
    }
}

enum PetSpecies: String, CaseIterable, Codable {
    case cat = "🐱"
    case dog = "🐶"
    case rabbit = "🐰"
    case fox = "🦊"
    case panda = "🐼"
    case frog = "🐸"
}

enum Planet: String, CaseIterable, Codable {
    case earth = "🌍"
    case moon = "🌕"
    case mars = "♂️"
    case jupiter = "♃"
    case saturn = "♄"
}

struct Postcard: Identifiable, Codable {
    let id: String
    let planet: Planet
    let message: String
    let imageName: String
    let unlockRequirement: Int // Number of consecutive days required
    
    init(id: String = UUID().uuidString, planet: Planet, message: String, imageName: String, unlockRequirement: Int) {
        self.id = id
        self.planet = planet
        self.message = message
        self.imageName = imageName
        self.unlockRequirement = unlockRequirement
    }
} 