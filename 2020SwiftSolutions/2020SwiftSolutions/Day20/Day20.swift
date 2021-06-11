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
    
    var rowCount : Int {
        Int(pow(Double(tiles.count), 0.5))
    }
    
    func part1() {
        let total = corners(of: Set(tiles), rowsLeft: rowCount).reduce(1) { acc, tile in
            acc * tile.id
                
        }
        print(total)
    }
    
    func part2() {
        let tilePossibilities = Day20PuzzleCompletedTile()
            .getTile()
            .possibleConfigurations()
        
        var nessyCount = 0
        
        tilePossibilities.forEach {
            for y in 0 ..< $0.count - 2 {
                for x in 18 ..< $0[y].count - 1 {
                    if foundHead(in: $0, x: x, y: y) {
                        nessyCount += 1
                    }
                }
            }
        }
        
        print(tilePossibilities.first!.reformStringFromLines().filter { $0 == "#"}.count - nessyCount*15)
        
    }
    
    func getRows() -> [[String]] {
        var rows = [[String]]()
        var myTiles = Set(tiles)
        
        while rows.count < rowCount {
            if let newRow = getRow(in: &myTiles, rowsLeft: rowCount - rows.count) {
                rows.append(newRow)
            }
        }
        
        return rows
        
    }
    
    func corners(of : Set<Tile>, rowsLeft : Int) -> [Tile] {
        of.filter { tile in
            of.filter({ $0.canBeMatched(with: tile) }).count == ((rowsLeft > 1) ? 2 : 1)
        }
    }
    
    func firstCorner(of : Set<Tile>, rowsLeft : Int) -> Tile? {
        
        for tile in of {
            let matches = of.filter({ $0.canBeMatched(with: tile) })
            if (rowsLeft == 1) ? (matches.count == 1) : (matches.count == 2) {
                return tile
            }
        }
        
        return nil
    }
    
    func getRow(in tiles : inout Set<Tile>, rowsLeft : Int) -> [String]? {
        let corner = firstCorner(of: tiles, rowsLeft: rowsLeft)!
        tiles.remove(corner)
        
        let tilesAtStart = tiles
        let nextSteps = Array(tiles.filter {  $0.canBeMatched(with: corner) })
        
        let nextStep = nextSteps.last!
        tiles.remove(nextStep)
        let firstAnswer = getRowFromStartingPoint(starting: combine(this: corner.tile, with: nextStep.tile), tiles: &tiles)
       
        
        if (firstAnswer.first!.count == rowCount*10) {
            return firstAnswer
        } else {
            tiles = tilesAtStart
            let alternateStep = nextSteps.first!
            tiles.remove(alternateStep)
            return getRowFromStartingPoint(starting: combine(this: corner.tile, with: alternateStep.tile), tiles: &tiles)
            
        }
        
    }
    
    func getRowFromStartingPoint(starting : [String], tiles : inout Set<Tile>) -> [String] {
        var currentRow = starting
        
        for _ in 0 ..< rowCount {
            tiles.forEach { next in
            
                if next.canBeMatched(with: currentRow) && tiles.contains(next) {
                    currentRow = combine(this: currentRow, with: next.tile)
                    tiles.remove(next)
                }
                
            }
        }
        
        return currentRow
    }
}

class Day20PuzzleCompletedTile : PuzzleClass {
    
    func getTile() -> [String] {
        let beforeTrimming = Array(inputStringUnparsed!.components(separatedBy: .newlines).dropLast())
        
        var newLines = [String]()
        
        for y in beforeTrimming.indices {
            if !(y % 10 == 0 || y % 10 == 9) {
                newLines.append(beforeTrimming[y])
            }
        }
        
        var answer = [String]()
        
        for y in newLines.indices {
            var newLine = ""
            for x in 0 ..< newLines[y].count {
                if !(x % 10 == 0 || x % 10 == 9) {
                    newLine += String(newLines[y][x])
                }
            }
            answer.append(newLine)
        }
        
        return answer
    }
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2020/2020SwiftSolutions/2020SwiftSolutions/Day20/Day20CompletedPuzzle.txt")
    }
    
}


struct Tile : Equatable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id : Int
    let tile : [String]
    
    func canBeMatched(with tile : Tile) -> Bool {
        self != tile && sidesWithReversed.filter { tile.sidesWithReversed.contains($0) }.count > 0
    }
    
    func canBeMatched(with raw : [String]) -> Bool {
        Tile(id: -1, tile : raw).canBeMatched(with: self)
    }
    
    var sidesWithReversed : Set<String> {
        sides.union(Set(sides.map { String($0.reversed()) }))
    }
    
    var sides : Set<String> {
        Set([top, left, right, bottom])
    }
    
    var top : String {
        tile.first!
    }
    
    var left : String {
        tile.left
    }
    
    var right : String {
        tile.right
    }
    
    var bottom : String {
        tile.last!
    }
}

func combine(this : [String], with : [String]) -> [String] {
    guard let correctOrientationOfOther = with.possibleConfigurations().first(where: { $0.left == this.right }) else {
        return combine(this: this.rotatedBy90(), with: with)
    }
    
    var answer = [String]()
    
    this.indices.forEach {
        answer.append(String(this[$0]) + correctOrientationOfOther[$0])
    }
    
    return answer
}

extension Collection where Element == String {
    
    var left : String {
        self.indices.reduce("") { acc, next in
            acc + String(self[next].first!)
        }
    }
    
    var right : String {
        self.indices.reduce("") { acc, next in
            acc + String(self[next].last!)
        }
    }
    
    func rotatedBy90() -> [String] {
        var answer = [String]()
        
        (0 ..< count).forEach { index in
            var runningLineTotal = ""
            forEach { line in
                    runningLineTotal += String(line[index])
            }
            answer.append(String(runningLineTotal.reversed()))
        }
        
        return answer
    }
    
    
    func possibleConfigurations() -> [[String]] {
        var rotated = [rotatedBy90()]
        
        (1 ... 3).forEach { _ in
            rotated.append(rotated.last!.rotatedBy90())
        }
        
        return rotated + rotated.map { $0.reversed() } 
    }
    
    func reformStringFromLines() -> String {
        self.reduce("") { acc, next in
            acc + "\n" + next
        }
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

func matches(for regex: String, in text: String) -> [String] {
    do {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
        return results.map {
            String(text[Range($0.range, in: text)!])
        }
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}

func foundHead(in map : [String], x : Int, y : Int) -> Bool {
    if map[y][x] == "#" {
        let body = map[y + 1]
        let tail = map[y + 2]
        
        return [1,0,-1,-6,-7,-12,-13,-18].allSatisfy({ offset in
            body[x + offset] == "#"
        }) && [-17, -14, -11, -8, -5, -2].allSatisfy({ offset in
            tail[x + offset] == "#"
        })
    }
    
    return false
}
