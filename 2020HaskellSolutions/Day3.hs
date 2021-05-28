module Day3 where

import Helpers

day3FilePath = "/Users/calebjw/Documents/Developer/AdventOfCode/2020/Inputs/Day3Input.txt"


findAmountOfTreesHit :: Int -> Int -> (Int, Int) -> Int -> [String] -> Int
findAmountOfTreesHit x y m current slopes = answer
    where (run,fall) = m
          newTotal = current + if slopes!!y!!x == '#' then 1 else 0
          newX = getCircularIndex (head slopes) (x + run)
          answer
            | y >= length slopes = current
            | otherwise = findAmountOfTreesHit newX (y + fall) m newTotal slopes

treesHitFromOrigin :: (Int, Int) -> [String] -> Int
treesHitFromOrigin m = findAmountOfTreesHit 0 0 m 0

part1 :: String -> Int
part1 input = treesHitFromOrigin (3,1) $ lines input

part2 :: String  -> Int
part2 input = foldl (\acc m -> treesHitFromOrigin m slopes * acc) 1 [(1,1),(3,1),(5,1),(7,1),(1,2)]
    where slopes = lines input

main :: IO()
main = do inputText <- readFile day3FilePath
          print $ part2 inputText