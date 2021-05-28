import java.io.File

object Day4 {
    private val inputDocuments = File("/Users/calebjw/Documents/Developer/AdventOfCode/2020/Inputs/Day4Input.txt").readText().split("\n\n")

    fun part1() = print(parseInput().count { it.containsRequiredFields() })
    fun part2() = print(parseInput().count { it.isValidPassport() })

    private fun parseInput() = inputDocuments.map { Passport(it) }

}

class Passport(string : String) {
    private val details : Map<String, String>

    init {
        val fields = string.splitByWhiteSpace().map { it.split(":") }
        details = fields.associate { it.first() to it.last() }
    }

    fun isValidPassport() = containsRequiredFields() && validYears() && validPhysicals() && validPassportID()

    fun containsRequiredFields() = details.size == 8 || details.size == 7 && details["cid"] == null

    private fun validYears() = validBirthYear() && validIssueYear() && validExpirationYear()

    private fun validBirthYear() = "byr".isYearInRange(1920..2002)

    private fun validIssueYear() = "iyr".isYearInRange(2010..2020)

    private fun validExpirationYear() = "eyr".isYearInRange(2020..2030)

    private fun validPhysicals() = validHeight() && validHairColor() && validEyeColor()

    private fun validHeight() : Boolean {
        val heightString = details["hgt"]!!
        val number = heightString.filter { it.isDigit() }.toInt()

        return when (heightString.takeLast(2)) {
            "cm" -> (150..193).contains(number)
            "in" -> (59..76).contains(number)
            else -> false
        }
    }

    private fun validHairColor() : Boolean {
        val hairColorString = details["hcl"]!!
        val regex = "#[a-f0-9]{6}\$".toRegex()

        return regex.find(hairColorString) != null
    }

    private fun validEyeColor() = listOf("amb","blu","brn","gry","grn","hzl","oth").contains(details["ecl"]!!)

    private fun validPassportID() = "^[0-9]{9}\$".toRegex().find(details["pid"]!!) != null

    private fun String.isYearInRange(range : IntRange) = range.contains(details[this]!!.toInt())
}

fun String.splitByWhiteSpace() = this.split("\\s".toRegex()).filter { it != ""}