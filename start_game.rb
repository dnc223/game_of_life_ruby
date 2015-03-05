require "gosu"

class Game < Gosu::Window
  attr_accessor :width, :board, :size, :alive

  def initialize
    @width = 500
    @size = @width / 10
    super(width, width, false)
    @board = Array.new(size) {Array.new(size, 0)}
    @board.each_with_index do |row, i|
      row.each_with_index do |element, j|
        @board[i][j] = rand(2)
      end
    end
    
    @alive = 0
  end

  def button_down(id)
    case id
    when Gosu::KbQ then close
    end
  end

  def draw
    # draw grid
    i = 0
    while i <= 500
      draw_line(i, 0, Gosu::Color::GRAY, i, width, Gosu::Color::GRAY)
      draw_line(0, i, Gosu::Color::GRAY, width, i, Gosu::Color::GRAY)
      i += 10
    end
    draw_board
    @board = get_next_board
    sleep(0.25)
  end

  def get_next_board
    next_board = Array.new(size) {Array.new(size, 0)}
    @board.each_with_index do |row, i|
      row.each_with_index do |alive, j|
        neighbors = get_neighbors(i, j)
        if alive == 0
          if neighbors == 3
            next_board[i][j] = 1
          end
        else
          case
          when neighbors < 2
            next_board[i][j] = 0
          when neighbors == 2 || neighbors == 3
            next_board[i][j] = 1
          when neighbors > 3
            next_board[i][j] = 0
          end
        end
      end
    end
    return next_board
  end

  def get_neighbors(i, j)
    count = 0

    case
    when i == 0
      case
      when j == 0
        count += @board[i][j + 1]
        count += @board[i + 1][j]
        count += @board[i + 1][j + 1]
      when j == @size - 1
        count += @board[i][j - 1]
        count += @board[i + 1][j]
        count += @board[i + 1][j - 1]
      else
        count += @board[i][j - 1]
        count += @board[i][j + 1]
        count += @board[i + 1][j - 1]
        count += @board[i + 1][j]
        count += @board[i + 1][j + 1]
      end
    when i == @size - 1
      case 
      when j == 0
        count += @board[i][j + 1]
        count += @board[i - 1][j]
        count += @board[i - 1][j + 1]
      when j == @size - 1
        count += @board[i][j - 1]
        count += @board[i - 1][j]
        count += @board[i - 1][j - 1]
      else
        count += @board[i][j - 1]
        count += @board[i][j + 1]
        count += @board[i - 1][j - 1]
        count += @board[i - 1][j]
        count += @board[i - 1][j + 1]
      end
    else
      case
      when j == 0
        count += @board[i - 1][j] + @board[i - 1][j + 1] + @board[i][j + 1] + @board[i + 1][j] + @board[i + 1][j + 1]
      when j == @size - 1
        count += @board[i - 1][j - 1] + @board[i - 1][j] + @board[i][j - 1] + @board[i + 1][j - 1] + @board[i + 1][j]
      else
        count += @board[i - 1][j - 1] + @board[i - 1][j] + @board[i - 1][j + 1] +
                 @board[i][j - 1] + @board[i][j + 1] +
                 @board[i + 1][j - 1] + @board[i + 1][j] + @board[i + 1][j + 1]
      end
    end
    return count
  end

  def draw_board
    @board.each_with_index do |row, i|
      row.each_with_index do |alive, j|
        if alive == 1
          color = Gosu::Color::GREEN
        else
          color = Gosu::Color::BLACK
        end
        draw_quad(i * 10 + 1, j * 10 + 1, color,
                  i * 10 + 9, j * 10 + 1, color,
                  i * 10 + 9, j * 10 + 9, color,
                  i * 10 + 1, j * 10 + 9, color
                 )
        
      end
    end
  end

end


game = Game.new
game.show