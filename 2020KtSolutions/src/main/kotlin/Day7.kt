import java.io.File
import java.util.*

object Day7 {
    private val inputLines = File("/Users/calebjw/Documents/Developer/AdventOfCode/2020/Inputs/Day7Input.txt").readLines()

    fun part1() {
        println(getNumberOfBagsContaining("shiny gold"))
    }

    fun part2() {
        println(getAmountsOfBagsIn("shiny gold", parseInput()))
    }

    private fun getNumberOfBagsContaining(string : String) : Int {
        val queue = ArrayDeque<String>()
        val allBags = parseInput()
        val alreadyUsed = mutableSetOf<String>()
        var counter = 0
        queue.add(string)

        while (queue.isNotEmpty()) {
            val currentBag = queue.removeFirst()

            if (!alreadyUsed.contains(currentBag)) {
                alreadyUsed.add(currentBag)
                counter += 1

                val thoseContainingCurrent = allBags.filter { it.value[currentBag] != null }
                queue.addAll(thoseContainingCurrent.keys)
            }
        }

        return counter - 1
    }

    private fun getAmountsOfBagsIn(bag : String, bags : Map<String,Map<String, Int>>) : Int {
        val contents = bags[bag]!!
        if (contents.isEmpty()) {
            return 0
        }

        var total = 0


        contents.forEach {  (key,amount) ->
            total += amount*(1 + getAmountsOfBagsIn(key,bags))
        }

        return total
    }

    private fun parseInput() : Map<String,Map<String, Int>> {
        val workingMap = mutableMapOf<String, Map<String, Int>>()

        val otherItemRegex = "([0-9]) (.+) bags?\\.?".toRegex()

        inputLines.forEach { line ->
            val parts = line.split(" bags contain ")
            val key = parts.first()
            if (parts.last() == "no other bags.") {
                workingMap[key] = emptyMap()
            } else {
                val values = parts.last().split(", ")
                val foundPatterns = values.map { otherItemRegex.find(it)!!.destructured }
                val dictionaryValues = foundPatterns.associate { (amount, name) ->
                    name to amount.toInt()
                }
                workingMap[key] = dictionaryValues
            }

        }

        return workingMap
    }

}