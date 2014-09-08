# Adventure game
# Pages 149-158

class Dungeon
        attr_accessor :player

        def initialize(player_name)
                @player = Player.new(player_name)
                @rooms = []
        end

        def add_room(reference, name, description, connections)
                @rooms << Room.new(reference, name, description, connections)
        end

        def start(location)
                @player.location = location
                show_current_description
        end

        def show_current_description
                puts find_room_in_dungeon(@player.location).full_description
        end

        def find_room_in_dungeon(reference)
                @rooms.detect { |room| room.reference == reference}
        end

        #returns nil if player can't go this way
        def find_room_in_direction(direction)
                find_room_in_dungeon(@player.location).connections[direction]
        end

        def go(direction)
               while find_room_in_direction(direction.to_sym) == nil
                        puts "You can't go that way!"
                        direction = gets.chomp
                end
                puts "You go " + direction.to_s
                @player.location = find_room_in_direction(direction.to_sym)
                show_current_description
        end

        class Player
                attr_accessor :name, :location

                def initialize(name)
                        @name = name
                end
        end

        class Room
                attr_accessor :reference, :name, :description, :connections

                def initialize(reference, name, description, connections)
                        @reference = reference
                        @name = name
                        @description = description
                        @connections = connections
                end

                def full_description
                        @name + ": You are in " + @description
                end
        end
end
$score = 0 

class Thing
        # accessor = things you want to access later in addition to your methods e.g. .name
        attr_accessor :id, :name, :message, :scorch

        # when you make a thing, what do you want to set upon instantiation? these are your init args
        def initialize(id, name, message, scorch)
                @id = id
                @name = name
                @message = message
                @scorch = scorch # score + change = scorch
        end
end

# main

puts "Enter your name:"
your_name = gets.chomp
your_dungeon = Dungeon.new(your_name) 

# Add rooms to the dungeon
your_dungeon.add_room(:largecave, "Large Cave", "a large cavernous cave", {:west => :smallcave, :east => :outside})
your_dungeon.add_room(:smallcave, "Small Cave", "a small, claustrophobic cave", {:east => :largecave})
your_dungeon.add_room(:outside, "Outside", "a grassy area outside the cave", {:west => :largecave, :north => :forest, :south => :forest, :east => :forest})
your_dungeon.add_room(:forest, "Forest", "a forest that goes on forever", {:west => :outside})

# Create my things
dinner = Thing.new(1, "dinner", "You found dinner! Your score increased by 2 points.", 2)
roller_coaster = Thing.new(2, "roller coaster", "You found a roller coaster. Roller coasters suck. Your score decreased by 1 point.", -1)
hug = Thing.new(3, "hug", "You found a hug! Your score increased by 5 points.", 5)
demise = Thing.new(4, "demise", "You found an untimely demise.",0)
ants = Thing.new(5, "ants", "You found ants. Everywhere. Radical! Your score increased by 10 points.", 10)
empty = Thing.new(0, nil,"", 0)

stuff = dinner, roller_coaster, hug, demise, ants, empty

#Function for making things randomly
def thing_maker(thingy)
    blah = thingy.sample
    if blah.id != 0
            puts blah.message
    end
    inc = blah.scorch
    $score += inc
    return blah.id
end


# Start the dungeon by placing the player in the large cave
your_dungeon.start(:largecave)

selection = nil

VALID = ["north", "south", "east", "west", "exit"]
#Navigate
selection = nil
while true
       #  your_dungeon.show_current_description
        puts "Enter a direction (or exit):"
        selection = gets.chomp
        if !(VALID.include?(selection))
                puts "Invalid direction. Choose either north, south, east, or west"
                redo #want to send back to beginning of loop
        end
        if selection == "exit"
                puts "Exiting. Your score was #{$score}."
                exit
        end 
        your_dungeon.go(selection.to_sym)
        die = thing_maker(stuff)
        puts "Your score is #{$score}"
        if die == 4
                exit
        end
end

        

