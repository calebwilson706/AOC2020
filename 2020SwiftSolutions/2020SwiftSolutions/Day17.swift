//
//  Day17.swift
//  2020SwiftSolutions
//
//  Created by Caleb Wilson on 01/06/2021.
//

import Foundation
import PuzzleBox

class Day17 {
    
    let start =
            """
            ##..#.#.
            ###.#.##
            ..###..#
            .#....##
            .#..####
            #####...
            #######.
            #.##.#.#
            """.components(separatedBy: .newlines)
    
    var initialMap : [Point3D : Bool] {
        var result = [Point3D : Bool]()
        
        start.indices.forEach { y in
            (0 ..< start[y].count).forEach { x in
                result[Point3D(x: x, y: y, z: 0)] = start[y][x] == "#"
            }
        }
        
        return result
    }
    
    var initialMapPart2 : [Point4D : Bool] {
        var result = [Point4D : Bool]()
        
        start.indices.forEach { y in
            (0 ..< start[y].count).forEach { x in
                result[Point4D(x: x, y: y, z: 0, w : 0)] = start[y][x] == "#"
            }
        }
        
        return result
    }
    
    func part1() {
        let startWidth = start.first!.count
        let startHeight = start.count
        var map = initialMap
        
        for cycle in 1 ... 6 {
            var working = [Point3D : Bool]()
            (-cycle ... cycle).forEach { z in
                startWidth.buildRange(cycle: cycle).forEach { x in
                    startHeight.buildRange(cycle: cycle).forEach { y in
                        let current = Point3D(x: x, y: y, z: z)
                        working[current] = current.getNextStatus(in: map)
                    }
                }
            }
            map = working
        }
        
        print(map.values.filter { $0 }.count)
    }
    
    func part2() {
        let startWidth = start.first!.count
        let startHeight = start.count
        var map = initialMapPart2
        
        for cycle in 1 ... 6 {
            var working = [Point4D : Bool]()
            (-cycle ... cycle).forEach { w in
                (-cycle ... cycle).forEach { z in
                    startWidth.buildRange(cycle: cycle).forEach { x in
                        startHeight.buildRange(cycle: cycle).forEach { y in
                            let current = Point4D(x: x, y: y, z: z, w : w)
                            working[current] = current.getNextStatus(in: map)
                        }
                    }
                }
            }
            map = working
        }
        
        print(map.values.filter { $0 }.count)
    }
}

extension Point4D {
    func getNextStatus(in map : [Point4D : Bool]) -> Bool {
        let currentState = map[self] == true
        var amountOfActiveNeighbours = 0
        
        for neighbour in neighbours {
            amountOfActiveNeighbours += (map[neighbour] == true).toInt()
            if amountOfActiveNeighbours > 3 {
                return false
            }
        }
        
        return (currentState && (2...3).contains(amountOfActiveNeighbours)) || (!currentState && amountOfActiveNeighbours == 3)
    }
}

extension Point3D {
    func getNextStatus(in map : [Point3D : Bool]) -> Bool {
        let currentState = map[self] == true
        var amountOfActiveNeighbours = 0
        
        for neighbour in neighbours {
            amountOfActiveNeighbours += (map[neighbour] == true).toInt()
            if amountOfActiveNeighbours > 3 {
                return false
            }
        }
        
        return (currentState && (2...3).contains(amountOfActiveNeighbours)) || (!currentState && amountOfActiveNeighbours == 3)
    }
}


extension Int {
    var adjacentAndSelf : ClosedRange<Int> {
        self - 1 ... self + 1
    }
    
    func buildRange(cycle : Int) -> Range<Int> {
        -cycle ..< self + cycle
    }
}
