# frozen_string_literal: true

class TodosController < ApplicationController
  before_action :set_todo, only: %i[show update destroy]

  def index
    @todos = paginate(@api_current_user.todos)
    render_json(@todos)
  end

  def create
    @todo = @api_current_user.todos.new(todo_params)
    if @todo.save
      render_json(@todo, :created)
    else
      render_json({ errors: @todo.errors.full_messages }, :unprocessable_entity)
    end
  end

  def show
    @todo = @todo.attributes.merge('items' => @todo.items)
    render_json(@todo)
  end

  def update
    if @todo.update(todo_params)
      render_json(@todo)
    else
      render_json({ errors: @todo.errors.full_messages }, :unprocessable_entity)
    end
  end

  def destroy
    if @todo.destroy
      head :no_content
    else
      render_json({ errors: @todo.errors.full_messages }, :unprocessable_entity)
    end
  end

  private

  def todo_params
    params.require(:todo).permit(:title, :description, :user_id, items_attributes: %i[title is_completed])
  end

  def set_todo
    @todo = Todo.find(params[:id])
    if @todo.user_id == @api_current_user.id
      @todo
    else
      render_json({ message: 'Not authorized' }, :unauthorized)
    end
  end
end
