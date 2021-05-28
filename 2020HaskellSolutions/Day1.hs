module Day1 where

import Helpers
day1FilePath = "/Users/calebjw/Documents/Developer/AdventOfCode/2020/Inputs/Day1Input.txt"

parse :: String -> [Int]
parse string = map read $ lines string

part1 :: String -> IO ()
part1 = solution 2

part2 :: String -> IO ()
part2 = solution 3

solution :: Int -> String -> IO()
solution n input = print $ product answer
    where answer = head $ filter (\xs -> sum xs == 2020) $ subsets n (parse input)

main :: IO()
main = do inputText <- readFile day1FilePath
          part2 inputText