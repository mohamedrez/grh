class DeleteUnusedMigrations < ActiveRecord::Migration[7.0]
  def up
    remove_column :users, :avatar_url if column_exists?(:users, :avatar_url)
    remove_column :users, :uid if column_exists?(:users, :uid)
    remove_column :users, :provider if column_exists?(:users, :provider)
    remove_column :users, :learning_goal if column_exists?(:users, :learning_goal)
    remove_column :users, :username if column_exists?(:users, :username)
    remove_column :lectures, :teacher if column_exists?(:lectures, :teacher)
    remove_index :courses, :position if index_exists?(:courses, :position)
    drop_table :user_points if table_exists?(:user_points)
    drop_table :user_quiz_responses if table_exists?(:user_quiz_responses)
    remove_columns :quizzes, :surveyjs, :answer if column_exists?(:quizzes, :surveyjs) && column_exists?(:quizzes, :answer)
    drop_table :user_progresses if table_exists?(:user_progresses)
    remove_column :steps, :name if column_exists?(:steps, :name)
    drop_table :quizzes if table_exists?(:quizzes)
    drop_table :lectures if table_exists?(:lectures)
    drop_table :steps if table_exists?(:steps)
    drop_table :courses if table_exists?(:courses)
    drop_table :tracks if table_exists?(:tracks)
  end

  def down
    # Recreate the tables and columns
    create_table(:tracks) do |t|
      t.string(:name)
      t.integer(:position)
      t.timestamps
    end

    create_table(:courses) do |t|
      t.references(:track, null: false, foreign_key: true)
      t.string(:name)
      t.integer(:position)
      t.timestamps
    end

    create_table(:steps) do |t|
      t.references(:course, null: false, foreign_key: true)
      t.integer(:position)
      t.references(:stepable, polymorphic: true, null: false)
      t.timestamps
    end

    create_table(:lectures) do |t|
      t.string(:youtube_video_link)
      t.timestamps
    end

    create_table(:quizzes) do |t|
      t.timestamps
    end

    add_column :steps, :name, :string

    create_table(:user_progresses) do |t|
      t.integer(:status)
      t.references(:user, null: false, foreign_key: true)
      t.references(:progressable, polymorphic: true, null: false)
      t.timestamps
    end

    add_column :quizzes, :surveyjs, :text
    add_column :quizzes, :answer, :string

    create_table :user_quiz_responses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :quiz, null: false, foreign_key: true
      t.string :response
      t.timestamps
    end

    create_table :user_points do |t|
      t.references :user, null: false, foreign_key: true
      t.references :scorable, polymorphic: true, null: false
      t.boolean :check?, default: false
      t.integer :point
      t.timestamps
    end

    add_index :courses, :position, unique: true

    add_column :lectures, :teacher, :string

    add_column :users, :learning_goal, :text
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :avatar_url, :string
  end
end
