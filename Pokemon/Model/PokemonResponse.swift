//
//  PokemonResponse.swift
//  Pokedex
//
//  Created by Jaafar Barek on 21/10/2024.
//

import Foundation

struct PokemonResponse: Codable {
    var count: Int
    var next: String
    var results: [PokemonResult]
}

struct PokemonResult: Codable {
    var name: String
    var url: String
}

struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let base_experience: Int
    let abilities: [Ability]
    let sprites: Sprites
    let types: [TypeElement]
}

struct Ability: Codable {
    let ability: AbilityDetail
}

struct AbilityDetail: Codable {
    let name: String
    let url: String
}

struct Sprites: Codable {
    let front_default: String?
    let back_default: String?
}

struct TypeElement: Codable {
    let type: TypeDetail
}

struct TypeDetail: Codable {
    let name: String
    let url: String
}

struct PokemonSpecies: Codable {
    let color: SpeciesColor
}

struct SpeciesColor: Codable {
    let name: String
}

