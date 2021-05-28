module Day5 where

import Helpers
day5FilePath = "/Users/calebjw/Documents/Developer/AdventOfCode/2020/Inputs/Day5Input.txt"

getPlacementGeneric :: Char -> Int -> String -> Int
getPlacementGeneric frontID numberOfPlaces = fst . foldl (updateRange frontID) (0,numberOfPlaces - 1)

updateRange :: Char -> (Int ,Int) -> Char -> (Int, Int)
updateRange frontID (low,high) character = answer
          where range = high - low
                change = range `div` 2 + 1
                frontHalf = (low,high - change)
                backHalf = (low + change,high)
                answer
                    | character == frontID = frontHalf
                    | otherwise  = backHalf

getRow :: String -> Int
getRow = getPlacementGeneric 'F' 128

getColumn :: String -> Int
getColumn = getPlacementGeneric 'L' 8

getCoordinate :: String -> (Int, Int)
getCoordinate string = (getRow rows, getColumn columns)
    where (rows,columns) = splitAt 7 string

idForSpot :: (Int, Int) -> Int
idForSpot (row,column) = row*8 + column

seatID :: String -> Int
seatID = idForSpot . getCoordinate

part1 :: String -> IO ()
part1 input = print $ foldl max 0 (map seatID (lines input))

part2 input = print $ idForSpot $ last $ filter (\point -> point `notElem` takenSeats && all (`elem` seatIDs) [idForSpot point + 1, idForSpot point - 1]) allSeats
    where takenSeats = map getCoordinate (lines input)
          seatIDs = map idForSpot takenSeats
          allSeats = getAllPoints (1,0) (126,7)

main :: IO()
main = do inputText <- readFile day5FilePath
          part2 inputText