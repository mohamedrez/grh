require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  let(:user) { create(:user, admin: true) }
  let(:task) { create(:task, user_id: user.id, author_id: user.id) }

  let(:valid_attributes) do
    {
      title: "Discord",
      due_date: "2022-04-27",
      link: "http://hachimy.com:8800/en/users/1/notes",
      description: "Dell Latitude E7450 Laptop, Intel Core i5, 8GB RAM, 256GB SSD, Windows 10 Pro"
    }
  end

  let(:invalid_attributes) do
    {
      title: "Discord",
      due_date: "",
      link: "http://hachimy.com:8800/en/users/1/notes",
      description: ""
    }
  end

  before do
    sign_in user
  end

  describe "GET /index" do
    it "renders a successful response" do
      get user_tasks_url(user_id: user.id)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_user_task_url(user_id: user.id)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_user_task_url(user_id: user.id, id: task.id )
      expect(response).to be_successful
    end
  end

  
  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new task" do
        expect {
          post "/users/#{user.id}/tasks", params: {task: valid_attributes}
        }.to change(Task, :count).by(1)
      end

      it "redirects to the tasks list" do
        post "/users/#{user.id}/tasks", params: {task: valid_attributes}
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid parameters" do
      it "does not create a new tasks" do
        expect {
          post "/users/#{user.id}/tasks", params: {task: invalid_attributes}
        }.to change(Task, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post "/users/#{user.id}/tasks", params: {task: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested task" do
        patch "/users/#{user.id}/tasks/#{task.id}", params: {task: valid_attributes}
        task.reload
        expect(task.title).to eq("Discord")
        expect(task.due_date).to eq(Date.new(2022, 4, 27))
        expect(task.link).to eq("http://hachimy.com:8800/en/users/1/notes")
        expect(task.description).to eq("Dell Latitude E7450 Laptop, Intel Core i5, 8GB RAM, 256GB SSD, Windows 10 Pro")
      end

      it "redirects to the tasks list" do
        patch "/users/#{user.id}/tasks/#{task.id}", params: {task: valid_attributes}
        task.reload
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch "/users/#{user.id}/tasks/#{task.id}", params: {task: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    before do
      delete "/users/#{user.id}/tasks/#{task.id}"
    end

    it "destroys the expense" do
      expect(Task.count).to eq(0)
    end
    it 'sets the flash notice' do
      expect(flash[:notice]).to eq(I18n.t("flash.successfully_destroyed"))
    end
  end
end
