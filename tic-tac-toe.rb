class Game

  @SQUARES = 9

  def initialize
    @P1 = Player.new(1, "X")
    @P2 = Player.new(2, "O")
    initialize_variables()
    menu()
  end

  private

  def initialize_variables
    @timer = 9
    @board = [" ", " ", " "]
    @board = @board.zip(@board, @board)
    result = []
    3.times { |x| 3.times { |y| result << [x, y] }}
    zip = *(1..9).zip(result)
    @COORDS = zip.to_h
  end

  def menu
    puts "    --------------------------"
    puts "    | WELCOME TO TIC-TAC-TOE |"
    puts "    --------------------------"
    puts "    | 1. Start new game      |"
    puts "    | 2. Quit                |"
    puts "    --------------------------"
    choice = validate_input(2)
    start_game() if choice == 1
    exit if choice == 2
  end

  def start_game
    while @timer > 0
      puts "Rounds left: #{@timer}"
      currentPlayer = (@timer.odd?) ? @P1 : @P2
      play_turn(currentPlayer)
      check_horizontal
      @timer -= 1
    end
    game_over("Nobody")
  end

  def validate_input(menu_item)
    choice = ""
    until choice.to_i.between?(1, menu_item) do
      puts "Please select a valid menu item." unless choice == ""
      print "> "
      choice = gets.chomp
    end
    choice.to_i
  end

  def play_turn(player)
    draw_board()
    puts "Player #{player.id}, please select an empty square to play your #{player.mark}."
    valid = false
    unless valid then
      input = validate_input(9)
      coord = @COORDS[input]
      if @board[coord[0]][coord[1]] == " "
        @board[coord[0]][coord[1]] = player.mark
        valid = true
      else
        puts "That square is already taken.  Please choose a different one."
        @timer += 1
      end
    end
  end

  def draw_board
    puts " #{@board[0][0]} | #{@board[0][1]} | #{@board[0][2]} "
    puts "-1---2---3- "
    puts " #{@board[1][0]} | #{@board[1][1]} | #{@board[1][2]} "
    puts "-4---5---6- "
    puts " #{@board[2][0]} | #{@board[2][1]} | #{@board[2][2]} "
    puts "-7---8---9-"
  end

  # debugging method
  # def set_board(arr)
  #   @board = arr
  # end

  def check_horizontal
    (@board.size).times do |index|
      if (@board[index][0] == @board[index][1]) &&
         (@board[index][2] == @board[index][0]) &&
         (@board[index][0] != " ")
        game_over(winner(@board[index][0]))
      end
    end
    check_vertical()
  end

  def check_vertical
    (@board.size).times do |index|
      3.times do |cindex|
        if(@board[0][cindex] == @board[1][cindex]) &&
          (@board[0][cindex] == @board[2][cindex]) &&
          (@board[0][cindex] != " ")
          game_over(winner(@board[0][cindex]))
        end
      end
    end
    check_diagonals()
  end

  def check_diagonals
    if (@board[0][0] == @board[1][1]) && (@board[0][0] == @board[2][2]) && (@board[0][0] != " ")
       game_over(winner(@board[0][0]))
    elsif (@board[0][2] == @board[1][1]) && (@board[2][0] == @board[0][2]) && (@board[0][2] != " ")
      game_over(winner(@board[0][2]))
    end
  end

  def winner(mark)
    (@P1.mark == mark) ? @P1 : @P2
  end

  def game_over(winner)
    draw_board
    puts "#{winner} wins!"
    puts "Press [ENTER] to continue"
    gets.chomp
    system("clear") || system("cls")
    initialize()
  end

  class Player
    attr_reader :id, :mark

    def initialize(id, mark)
      @id = id
      @mark = mark
    end

    def to_s
      "Player #{id}"
    end
  end #end Player class
end

game = Game.new
