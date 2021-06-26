//
//  Day20.swift
//  2020SwiftSolutions
//
//  Created by Caleb Wilson on 07/06/2021.
//

import Foundation
import PuzzleBox


class Day20 {
    let tiles = Day20InputParser().parse()
    
    func test() {
        tiles.forEach { tile in
            print(tiles.filter { canBeMatched(lhs: tile, rhs: $0) }.count)
        }
    }
}


func canBeMatched(lhs : Tile,rhs : Tile) -> Bool {
    lhs != rhs && lhs.sides.filter { rhs.sides.contains($0) }.count > 0
}

struct Tile : Equatable {
    let id : Int
    let tile : [String]
    
    var sides : [String] {
        [top, left, right, bottom]
    }
    
    var top : String {
        tile.first!
    }
    
    var left : String {
        (0 ..< tile.count).reduce("") { acc, next in
            acc + String(tile[next].first!)
        }
    }
    
    var right : String {
        (0 ..< tile.count).reduce("") { acc, next in
            acc + String(tile[next].last!)
        }
    }
    
    var bottom : String {
        tile.last!
    }
}

class Day20InputParser : PuzzleClass {
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2020/Inputs/Day20Input.txt")
    }
    
    func parse() -> [Tile] {
        inputStringUnparsed!.components(separatedBy: "\n\n").map {
            let lines = $0.components(separatedBy: "\n")
            let id = Int(lines.first!.filter(\.isNumber))!
            let tile = lines.dropFirst().map { ss in String(ss)}
            
            return Tile(id: id, tile: tile)
        }
    }
}
