class Jarmandy::BaseController < ApplicationController
  before_action :require_legitbs
  layout 'jarmandy'

  PER_PAGE = 25
end
