class GramsController < ApplicationController
  def index
  end

  def new
    @gram = Gram.new   # comment this line to make an error that tests don't catch
  end
end
