class AddIndexesToTables < ActiveRecord::Migration
  def change
    add_index :check_ins, :user_schedule_id
    add_index :check_ins, :user_id
    add_index :check_ins, :status

    add_index :department_assistants, :user_id
    add_index :department_assistants, :department_id

    add_index :department_blocks, :day_id
    add_index :department_blocks, :department_id

    add_index :department_managers, :user_id
    add_index :department_managers, :department_id

    add_index :flags, :check_in_id
    add_index :flags, :user_id

    add_index :user_availabilities, :user_id
    add_index :user_availabilities, :day_id

    add_index :user_charities, :user_id
    add_index :user_charities, :charity_id

    add_index :user_schedules, :department_block_id
    add_index :user_schedules, :user_id
    add_index :user_schedules, :charity_id
    
    add_index :volunteer_managers, :user_id
    add_index :volunteer_managers, :department_block_id
  end
end
