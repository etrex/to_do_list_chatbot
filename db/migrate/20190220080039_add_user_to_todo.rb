class AddUserToTodo < ActiveRecord::Migration[5.2]
  def change
    add_reference :todos, :user
  end
end
