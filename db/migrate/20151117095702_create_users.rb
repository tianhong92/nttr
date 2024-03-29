class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login, null: false
      t.string :nicename, null: false
      t.string :email, null: false
      t.string :login_md5
      t.string :crypted_password, null:  false
      t.string :password_salt, null:  false
      t.string :persistence_token, null:  false
      t.integer :login_count, default: 0, null:  false
      t.datetime :last_request_at
      t.datetime :last_login_at
      t.datetime :current_login_at
      t.string :last_login_ip
      t.string :current_login_ip

      t.timestamps null: false
    end
  end
end
