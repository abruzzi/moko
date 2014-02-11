require './moko_server'

Moko::Server.draw do
	resources :users, :posts
	
	resource :comment do |c|
		c.string :title
		c.string :body
		c.datetime :created_at
	end

	resource :product do |p|
		p.string :name
		p.float :price
	end

	resource :user do |u|
		u.string :name
		u.integer :arg
		u.string :type
		u.datetime :created_at
		u.datetime :updated_at
	end

    resource :property do |p|
        p.string :title
        p.string :address
        p.string :type
        p.integer :suburb
        p.string :highlight
        p.datetime :auction
        p.datetime :created_at
        p.datetime :updated_at
    end
end

