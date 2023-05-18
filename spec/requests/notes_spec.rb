require 'rails_helper'

RSpec.describe "Notes", type: :request do
  let(:user) { create(:user) } 
  let(:author) { create(:user)}
  let(:note) { create(:note, user_id: user.id, author_id: author.id) }
  let(:valid_attributes) { { content: "He's a good employee" } }
  let(:invalid_attributes) { { content: "" } }

  before do
    sign_in user
  end

  describe "GET /index" do
    it "renders a successful response" do
      get user_notes_url(user_id: user.id)
      expect(response).to be_successful 
    end
  end

  describe "GET /new" do
    it "renders a successful reponse" do
      get new_user_note_path(user_id: user.id)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do 
    it "renders a successful reponse" do
      get edit_user_note_path(user_id: user.id, id: note.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "When the user note is succesfully created" do
      before do
        post "/users/#{user.id}/notes", params: { note: valid_attributes}
      end

      it 'creates a new note' do
        expect(Note.count).to eq(1)
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:found)
      end

      it 'sets the flash notice' do
        expect(flash[:notice]).to eq( I18n.t("flash.successfully_created"))
      end
    end

    
    context 'when the note fails to save' do
      before do
        post "/users/#{user.id}/notes", params: { note: invalid_attributes }
      end

      it 'does not create a new note' do
        expect(Note.count).to eq(0)
      end

      it 'returns an unprocessable entity status' do
        expect(response)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      before do
        patch user_note_path(user_id: user.id, id: note.id), params: {note: valid_attributes}
      end

      it 'updates the requested announcement' do
        note.reload
        expect(note.content).to eq("He's a good employee")
      end

      it 'redirects to the note' do 
        note.reload
        expect(@reponse).to  redirect_to(user_notes_path(user_id: user.id))
      end
    end
  
    context 'when the note fails to update' do
      before do
        patch user_note_path(user_id: user.id, id: note.id), params: {note: invalid_attributes}
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    before do
      delete user_note_path(user_id: user.id, id: note.id)
    end

    it 'destroy the note' do
      expect(Note.count).to eq(0)
    end
    
    it 'sets the flash notice' do
      expect(flash[:notice]).to eq( I18n.t("flash.successfully_destroyed"))
    end
  end
end
