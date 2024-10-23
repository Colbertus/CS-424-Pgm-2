#=
	Author: Colby McClure
	Course: CS-424-01
	Assignment: Programming Assignment 2
    File Name: Programming_Assignment_2.jl
	Environment Info: VSCode on Windows 11

	Description: 	This program reads an input file containing baseball player statistics and calculates the batting average, 
					slugging percentage, and on base percentage for each player in the input file. The program will then generate
                    a report that displays the player's statistics sorted by decreasing slugging percentage and another report
                    that displays the player's statistics sorted by player name (using their last name, first name for any tie breaker). 
                    This program makes good use of the sort() function to sort the player objects in the players array by the desired
                    field (slugging percentage or player name) and then uses the @printf macro to print the formatted output in a table.
=#

module Programming_Assignment_2

# Initialize Printf for formatted output
using Printf

#= 
    Define a mutable Player struct that holds all of the input information along
    with the calculated batting average, slugging percentage, and on-base percentage,
    hence why this struct is mutable. 
=#
mutable struct Player 
    first_name::String
    last_name::String
    plate_appearances::Int64
    at_bats::Int64
    singles::Int64
    doubles::Int64
    triples::Int64
    home_runs::Int64
    walks::Int64
    hit_by_pitch::Int64
    batting_average::Float64
    slugging_percentage::Float64
    on_base_percentage::Float64

    # Define a constructor for the Player struct for easy creation of instances
    function Player(first_name::String, last_name::String, plate_appearances::Int64, at_bats::Int64, singles::Int64, doubles::Int64, triples::Int64, home_runs::Int64, walks::Int64, hit_by_pitch::Int64)
        new(first_name, last_name, plate_appearances, at_bats, singles, doubles, triples, home_runs, walks, hit_by_pitch)
    end

end # struct Player

# Define functions to calculate the batting average, slugging percentage, and on-base percentage
# All of which take a player object as an argument and return the calculated value
function BattingAverage(player::Player)
    return (player.singles + player.doubles + player.triples + player.home_runs) / player.at_bats
end

function SluggingPercentage(player::Player)
    return (player.singles + (2 * player.doubles) + (3 * player.triples) + (4 * player.home_runs)) / player.at_bats
end

function OnBasePercentage(player::Player)
    return (player.singles + player.doubles + player.triples + player.home_runs + player.walks + player.hit_by_pitch) / player.plate_appearances
end

# Start Message 
print("Welcome to the Baseball Player Statistics Program! Please enter the name of the input file: ")

# Read the input file from the user
input_file = readline()

# Initialize an empty array to hold all of the player objects
players = []

# Open the file and read each line
open(input_file) do file
    for line in eachline(file)

        # Split the line into an array of strings by using a space as a delimiter
        player_data = split(line, " ")

        # Create a new player object from each element in the player data array
        player = Player(String(player_data[1]), String(player_data[2]), parse(Int64, player_data[3]), 
                            parse(Int64, player_data[4]), parse(Int64, player_data[5]), 
                            parse(Int64, player_data[6]), parse(Int64, player_data[7]), 
                            parse(Int64, player_data[8]), parse(Int64, player_data[9]), parse(Int64, player_data[10]))
        
        # Calculate the batting average, slugging percentage, and on-base percentage for each player
        player.batting_average = BattingAverage(player)
        player.slugging_percentage = SluggingPercentage(player)
        player.on_base_percentage = OnBasePercentage(player)

        # Add the player object to the players array using the push! function
        push!(players, player)
    end 
end

# Get a count of the number of players in the players array for the report 
number_of_players = length(players)

# Sort the players array by slugging percentage in descending order
sorted_players = sort(players, by = player -> player.slugging_percentage, rev = true)

# Print the report header and the first report in a formatted table
println("BASEBALL STATISTICS REPORT --- $(number_of_players) PLAYERS FOUND IN FILE\n")
println("Report ordered by decreasing slugging percentage\n")
@printf("%-20s %-20s %-20s %-20s\n", "Player Name", "Average", "Slugging", "On-Base")
println("------------------------------------------------------------------------------")

for player in sorted_players
    @printf("%-20s %-20.3f %-20.3f %-20.3f\n", player.first_name * " " * player.last_name, player.batting_average, player.slugging_percentage, player.on_base_percentage)
end

# Sort the players array by player name in ascending order (in lowercase)
# If there is a tie in the last name, sort by first name
sorted_players = sort(players, by = p -> (lowercase(p.last_name), lowercase(p.first_name)))

# Print the second report in a formatted table
# This time, the report is ordered by player name (last name first, then first name)
println("\nReport ordered by player name\n")
@printf("%-20s %-20s %-20s %-20s\n", "Player Name", "Average", "Slugging", "On-Base")
println("------------------------------------------------------------------------------")

for player in sorted_players
    @printf("%-20s %-20.3f %-20.3f %-20.3f\n", player.first_name * " " * player.last_name, player.batting_average, player.slugging_percentage, player.on_base_percentage)
end

end # Programming_Assignment_2
