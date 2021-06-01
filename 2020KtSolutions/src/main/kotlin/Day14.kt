import java.io.File
import kotlin.math.pow

object Day14 {
    private val inputLines = File("/Users/calebjw/Documents/Developer/AdventOfCode/2020/Inputs/Day14Input.txt")
        .readLines()

    fun part1() {
        var mask = ""
        val registers = mutableMapOf<Int, Long>()

        inputLines.forEach {
            if (it.contains("mask")) {
                mask = updateMask(it)
            } else {
                val newAssignment = it.parseAssignment()
                registers[newAssignment.first] = newAssignment.second.applyBitmask(mask)
            }
        }

        println(registers.values.sum())
    }

    fun part2() {
        var mask = ""
        val registers = mutableMapOf<Long, Long>()

        inputLines.forEach { line ->
            if (line.contains("mask")) {
                mask = updateMask(line)
            } else {
                val newAssignment = line.parseAssignment()
                val possibleAddresses = newAssignment.first.decodeMemoryAddress(mask)
                possibleAddresses.forEach {
                    registers[it] = newAssignment.second.toLong()
                }
            }
        }

        println(registers.values.sum())
    }
    
    private fun updateMask(newAssignment : String) = newAssignment.drop(7)

    private fun Int.applyBitmask(mask : String) : Long {
        return this.toBinary().foldIndexed("") { index: Int, acc : String, character: Char ->
            val maskCharacter = mask[index]
            acc + if (maskCharacter.isFloating()) character else maskCharacter
        }.toLong(radix = 2)
    }

    private fun Int.decodeMemoryAddress(mask : String) : List<Long> {
        val masked = this.applyBitmaskV2(mask)
        return masked.getPossibilitiesForAddresses()
    }

    private fun Int.applyBitmaskV2(mask : String) : String {
        return this.toBinary().foldIndexed("") { index: Int, acc : String, character: Char ->
            val maskCharacter = mask[index]
            acc + when {
                maskCharacter.isFloating() -> 'X'
                maskCharacter == '0' -> character
                else -> '1'
            }
        }
    }

    private fun String.getPossibilitiesForAddresses() : List<Long> {
        val replacements = this.getPossibleReplacements()
        return replacements.map { this.replace(it).toLong(radix = 2) }
    }

    private fun String.getPossibleReplacements() : List<List<Int>> {
        val xCount = this.count { it == 'X' }
        val last = 2.0.pow(xCount).toInt()
        return (0 until last).map { number ->
            number.toString(radix = 2).padStart(xCount,'0').map { it.toString().toInt() }
        }
    }

    private fun String.replace(replacements : List<Int> ): String {
        var result = ""
        var currentReplacementIndex = 0

        this.forEach {
            if (it.isFloating()) {
                result += replacements[currentReplacementIndex]
                currentReplacementIndex += 1
            } else {
                result += it
            }
        }

        return result
    }

    private fun Int.toBinary() : String = this.toString(2).padStart(36,'0')

    private fun Char.isFloating() = this == 'X'

    private fun String.parseAssignment() : Pair<Int, Int> {
        val (key,value) = "mem\\[([0-9]+)\\] = ([0-9]+)".toRegex().find(this)!!.destructured
        return (key.toInt() to value.toInt())
    }
}

