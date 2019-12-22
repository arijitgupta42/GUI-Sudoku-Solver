class MyTest < Shoes
	url '/', :index
	url '/sudoku', :sudoku
	url '/solution', :solution

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

	def index
		@x = 0
		@y = 0
		@map = Array.new(10) { Array.new(9) } 
		num = 0

		@map.each { |el|
		    if(num!=0)
		        line(top:0,left:(num*50),width:0,height:450)
		    end
		    el.each { |el2|
		        if(num!=0)
		            line(top:(num*50),left:0,width:450,height:0)
		        end
		    }
		    num = num + 1
		}

		stack(top:460, left:80){
			button "Show sudoku" do
				visit '/sudoku'
			end
		}
		stack(top:460, left:230){
			button "Show solution" do
				visit '/solution'
			end
		}
	end

	def sudoku

		@x = 0
		@y = 0
		@map = Array.new(10) { Array.new(9) } 
		num = 0

		@map.each { |el|
		    if(num!=0)
		        line(top:0,left:(num*50),width:0,height:450)
		    end
		    el.each { |el2|
		        if(num!=0)
		            line(top:(num*50),left:0,width:450,height:0)
		        end
		    }
		    num = num + 1
		}

		stack(top:460, left:80){
			button "Show sudoku" do
				visit '/sudoku'
			end
		}
		stack(top:460, left:230){
			button "Show solution" do
				visit '/solution'
			end
		}
		for i in 0..($board.length-1)*50
			for j in 0..($board[0].length-1)*50
				stack(left: i*50 + 15, top: j*50 + 15){para $board[i][j]}
				j+=50
			end
			i+=50
		end
	end

	def solution
		@board = $board
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
		@x = 0
		@y = 0
		@map = Array.new(10) { Array.new(9) } 
		num = 0
		@map.each { |el|
		    if(num!=0)
		        line(top:0,left:(num*50),width:0,height:450)
		    end
		    el.each { |el2|
		        if(num!=0)
		            line(top:(num*50),left:0,width:450,height:0)
		        end
		    }
		    num = num + 1
		}
		stack(top:460, left:80){
			button "Show sudoku" do
				visit '/sudoku'
			end
		}
		stack(top:460, left:230){
			button "Show solution" do
				visit '/solution'
			end
		}
		solve(@board)
		for i in 0..($board.length-1)*50
			for j in 0..($board[0].length-1)*50
				stack(left: i*50 + 15, top: j*50 + 15){para @board[i][j]}
				j+=50
			end
			i+=50
		end
	end
end

Shoes.app(title:"Sudoku Solver in Ruby", width:(450), height:(500), resizable: false)
	

