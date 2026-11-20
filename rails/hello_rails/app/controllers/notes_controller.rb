class NotesController < ApplicationController
  def index
    @notes = Note.order(id: :desc)
  end
end
