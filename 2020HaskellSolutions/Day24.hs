module Day24 where

import qualified Data.Set as DS
import Helpers

data Dir = E | SE | SW | W | NW | NE deriving (Show, Eq, Ord, Enum)

day24FilePath = "/Users/calebjw/Documents/Developer/AdventOfCode/2020/Inputs/Day24Input.txt"

addHexPoint :: (Int, Int) -> (Int, Int)-> (Int, Int)
addHexPoint (x1,y1) (x2,y2) = (x1 + x2, y1 + y2)

neighbours :: (Int, Int) -> [(Int, Int)]
neighbours p = map (moveHexPoint p) [E .. NE]

moveHexPoint :: (Int, Int) -> Dir -> (Int, Int)
moveHexPoint originalPoint direction =
    addHexPoint originalPoint $ case direction of
        NE -> (1,1)
        E -> (1,0)
        SE -> (0,-1)
        SW -> (-1,-1)
        W -> (-1,0)
        NW -> (0,1)

getFinalPoint :: String -> (Int, Int)
getFinalPoint path = foldr (flip moveHexPoint) (0,0) (parseLine path)

parseLine :: String -> [Dir]
parseLine [] = []
parseLine (c:cs)
    | c == 'e' = E : parseLine cs
    | c == 'w' = W : parseLine cs
    | c == 's' = if head cs == 'e'
                    then SE : parseLine (tail cs)
                    else SW : parseLine (tail cs)
    | c == 'n' = if head cs == 'e'
                    then NE : parseLine (tail cs)
                    else NW : parseLine (tail cs)

flipTileAtEndOfPath :: String -> DS.Set (Int,Int) -> DS.Set (Int,Int)
flipTileAtEndOfPath path tiles = finalTile `myOperationToCarryOut` tiles
    where finalTile = getFinalPoint path
          isWhite = not $ finalTile `DS.member` tiles
          myOperationToCarryOut
            | isWhite = DS.insert
            | otherwise = DS.delete

getListOfStartingBlackTiles :: String -> DS.Set (Int, Int)
getListOfStartingBlackTiles = foldr flipTileAtEndOfPath (DS.fromList []) . lines

countBlackNeighbours :: (Int, Int) -> DS.Set (Int, Int) -> Int
countBlackNeighbours p tiles = foldr step 0 (neighbours p)
    where step point acc = acc + if point `DS.member` tiles then 1 else 0

getPointsToCheck :: DS.Set (Int, Int) -> [(Int, Int)]
getPointsToCheck prevTiles = getAllPoints (minX - 1, minY - 1) (maxX + 1, maxY + 1)
    where (minX, maxX, minY, maxY) = foldr step (dx,dx,dy,dy) prevTiles
          (dx,dy) = DS.elemAt 0 prevTiles
          step (x, y) (x1,x2,y1,y2) = (min x x1, max x x2, min y y1, max y y2)

getNextStatus :: (Int, Int) -> DS.Set (Int, Int) -> Bool 
getNextStatus point blackTiles = result
    where blackNeighbours = countBlackNeighbours point blackTiles
          isWhite = not $ point `DS.member` blackTiles
          result
            | isWhite = blackNeighbours == 2
            | otherwise  = blackNeighbours /= 0 && blackNeighbours < 3

updateFloor :: DS.Set (Int, Int) -> DS.Set (Int, Int)
updateFloor original = foldr step (DS.fromList []) $ getPointsToCheck original
    where step point acc = if getNextStatus point original then point `DS.insert` acc else acc

part1 :: String -> IO()
part1 = print . DS.size . getListOfStartingBlackTiles

part2 :: String -> IO()
part2 input = print $ DS.size $ foldl (\acc next -> updateFloor acc) (getListOfStartingBlackTiles input) [0..99]

main ::IO()
main = do inputText <- readFile day24FilePath
          part2 inputText