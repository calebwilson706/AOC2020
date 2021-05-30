//
//  Day11.swift
//  2020SwiftSolutions
//
//  Created by Caleb Wilson on 30/05/2021.
//

import Foundation
import PuzzleBox

class Day11 : PuzzleClass {
    
    var width = 0
    var height = 0
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2020/Inputs/Day11Input.txt")
    }
    
    func getInitialFloorPlanAndSetDimensions() -> [Point : Bool] {
        var map = [Point : Bool]()
        let inputLines = inputStringUnparsed!.components(separatedBy: .newlines)
        
        width = inputLines.first!.count
        height = inputLines.count
        
        (0 ..< inputLines.count).forEach { y in
            (0 ..< inputLines[y].count).forEach { x in
                if inputLines[y][x] == "L" {
                    map[Point(x: x, y: y)] = false
                }
            }
        }
        
        return map
    }
    
    func part1() {
        solution(countMethod: countSeatsTaken(beside:map:), limit: 4)
    }
    
    func part2() {
        solution(countMethod: countSeatsTaken(inSightLine:map:), limit: 5)
    }
    
    func solution(countMethod : (Point, [Point : Bool]) -> Int, limit : Int) {
        var map = getInitialFloorPlanAndSetDimensions()
        
        while true {
            let updatedMap = getNewMap(previous: map, countMethod: countMethod, limit: limit)
            if updatedMap == map {
                break
            } else {
                map = updatedMap
            }
        }
        
        print(map.values.filter { $0 }.count)
    }
    
    func getNewMap(previous : [Point : Bool], countMethod : (Point, [Point : Bool]) -> Int, limit : Int) -> [Point : Bool] {
        previous.reduce([Point : Bool]()) { acc, entry in
            var working = acc
            let point = entry.key
            working[point] = point.getNewStatus(previousMap: previous, countMethod: countMethod, limit: limit)
            return working
        }
    }
    
    func countSeatsTaken(beside point : Point, map : [Point : Bool]) -> Int {
        point.adjacent.reduce(0) { acc, neighbour in
            acc + (map[neighbour] ?? false).toInt()
        }
    }
    
    func countSeatsTaken(inSightLine point : Point, map : [Point : Bool]) -> Int {
        var total = 0
        
        (-1...1).forEach { x in
            (-1...1).forEach { y in
                if !(x == 0 && y==0) {
                    total += point.getFirstSeatInLine(rise: y, run: x, map: map, width: width, height: height).toInt()
                }
            }
        }
        
        return total
    }
    
    
}



extension Point {
    
    var adjacent : [Point] {
        [up(),upRight(),right(),downRight(),down(),downLeft(),left(),upLeft()]
    }
    
    func getNewStatus(previousMap : [Point : Bool], countMethod : (Point, [Point : Bool]) -> Int, limit : Int) -> Bool {
        let seatsTakenBeside = countMethod(self, previousMap)
        let previous = previousMap[self] == true
        
        
        return (!previous && seatsTakenBeside == 0) || (previous && seatsTakenBeside < limit)
    }
    
    static func +(lhs : Point, rhs : Point) -> Point {
        Point(x: (lhs.x + rhs.x),y: (lhs.y + rhs.y))
    }
    
    func getFirstSeatInLine(rise : Int, run : Int, map : [Point : Bool], width : Int, height : Int) -> Bool {
        let gradient = Point(x: run,y: rise)
        var point = self + gradient
        
        while (map[point] == nil && point.x >= 0 && point.y >= 0 && point.x < width && point.y < height) {
            point = point + gradient
        }
        
        return map[point] == true
    }
    
}

extension Bool {
    func toInt() -> Int {
        (self) ? 1 : 0
    }
}
