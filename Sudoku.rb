class String  #Defining colors to make string colorization possible
 
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def light_blue
    colorize(36)
  end  
end

puts "*********************************".red
puts "Welcome to the Ruby Sudoku Solver".red
puts "*********************************".red


#Defining the board to be solved
$board = [ 
        [7, 8, 0, 4, 0, 0, 1, 2, 0],
        [6, 0, 0, 0, 7, 5, 0, 0, 9],
        [0, 0, 0, 6, 0, 1, 0, 7, 8],
        [0, 0, 7, 0, 4, 0, 2, 6, 0],
        [0, 0, 1, 0, 5, 0, 9, 3, 0],
        [9, 0, 4, 0, 6, 0, 0, 0, 5],
        [0, 7, 0, 3, 0, 0, 0, 1, 2],
        [1, 2, 0, 0, 0, 7, 4, 0, 0],
        [0, 4, 9, 2, 0, 6, 0, 0, 7]
    ]

#Show the puzzle with proper markings for sqaures, rows and coloumns
def show_board(bo)
    for i in 0..bo.length-1 do
        if i%3 == 0 && i != 0
            puts "- - - - - - - - - - - - " 
        end

        for j in 0..bo[0].length-1 do
            if j%3 == 0 && j != 0
                print " | "
            end

            print bo[i][j].to_s + " "
        end
        puts ""
    end
end

#Find which positions need to be solved for
def find_null(bo)
    for i in 0..bo.length-1 do
        for j in 0..bo[0].length-1 do
            if bo[i][j] == 0
                return i, j
            end
        end
    end
    return nil
end

#Check if the solution proposed for the position is valid
def valid(bo, num, pos)
    for i in 0..bo[0].length-1 do
        if bo[pos[0]][i] == num && pos[1] != i
            return false
        end
    end

    for i in 0..bo.length-1 do
        if bo[i][pos[1]] == num && pos[0] != i
            return false
        end
    end

    box_x = pos[1] / 3
    box_y = pos[0] / 3

    for i in box_y*3..box_y*3+2 do
        for j in box_x*3..box_x*3+2 do
            if bo[i][j] == num && i != pos[0] && j != pos[1]
                return false
            end
        end
    end
    return true
end

#Recursive function that solves the puzzle block by block and checks validity along the way
def solve(bo)
    find = find_null(bo)
    if not find
        return true
    else
        for i in 1..9 do
            if valid(bo, i, find)
                bo[find[0]][find[1]] = i

                if solve(bo)
                    return true
                end

                bo[find[0]][find[1]] = 0
            end
        end
    end
    return false
end


show_board($board)
nulls = []

for i in 0..8 do
    for j in 0..8 do
        if $board[i][j] == 0
            nulls.push([i, j])
        end
    end
end

solve($board) #Calling the solve function
puts ""
puts "Solving...."
puts ""
if solve($board) #Printing solved board if solution possible
    puts "Solved!"
    puts ""
    for i in 0..8 do
        for j in 0..8 do
            for k in 0..nulls.length-1 do
                if i == nulls[k][0] and j == nulls [k][1]
                    $board[i][j] = $board[i][j].to_s.green
                end
            end
        end #Coloring the elements that were solved by the program
    end
    show_board($board)

else #Informing user that board does not have a valid solution
    puts "Cannot be solved"
    puts ""
end

