# frozen_string_literal: true

class TracksController < ApplicationController

  def index
    @tracks = Track.all
  end
end
