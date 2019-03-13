# coding: utf-8

class Command
  attr_reader :description
  def initialize(description)
    @description = description
  end

  def do
  end

  def undo
  end
end

class SetCommand < Command
  attr_reader :board,:x,:y,:number
  def initialize(board,x,y,number)
    super("Set #{number} to Board[#{board.object_id}][#{x},#{y}]")
    @board = board # 対象のBoardオブジェクト
    @x = x # X座標
    @y = y # Y座標
    @number = number # セットする数字
  end

  def do
    @board.set_number(@x,@y,@number)
  end

  def undo
    @board.set_number(@x,@y,nil)
  end
end

class CompositCommand < Command
  def initialize()
    @commands = []
  end

  def push(cmd)
    @commands.push(cmd)
  end

  def pop()
    @commands.pop
  end

  def do
    @commands.each { |cmd| cmd.do }
  end

  def undo
    @commands.reverse.each { |cmd| cmd.undo }
  end

  def description
    description = ""
    @commands.each { |cmd| description += cmd.description + "\n" }
    description
  end
end
