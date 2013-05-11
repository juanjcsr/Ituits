class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
  	#Agregar un indice a usuarios para verificar que el email sea unico
  	add_index :users, :email, unique: true
  end
end
