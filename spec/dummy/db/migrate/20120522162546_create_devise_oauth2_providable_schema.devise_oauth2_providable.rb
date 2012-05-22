# This migration comes from devise_oauth2_providable (originally 20111014160714)
class CreateDeviseOauth2ProvidableSchema < ActiveRecord::Migration
  def change
    create_table :oauth2_clients do |t|
      t.belongs_to :user
      t.string :name
      t.string :redirect_uri
      t.string :website
      t.string :identifier
      t.string :secret
      t.timestamps
    end

    add_index :oauth2_clients, :identifier, unique: true
    add_index :oauth2_clients, :user_id

    token_tables = %W{
      oauth2_access_tokens
      oauth2_refresh_tokens
      oauth2_authorization_codes
    }.map &:to_sym

    token_tables.each do |table_name|
      create_table table_name do |t|
        t.belongs_to :user, :client
        t.belongs_to :refresh_token if table_name == :oauth2_access_tokens
        t.string :token
        t.datetime :expires_at
        t.timestamps  
      end

      add_index table_name, :token, unique: true
      add_index table_name, :expires_at
      add_index table_name, :user_id
      add_index table_name, :client_id

      add_index table_name, :refresh_token_id if table_name == :oauth2_access_tokens
    end
  end
end