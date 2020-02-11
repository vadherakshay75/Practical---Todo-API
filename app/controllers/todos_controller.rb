# frozen_string_literal: true

# todos controller
class TodosController < ApplicationController
  before_action :set_todo, only: %i[show update destroy]

  def index
    @todos =
      if params[:is_completed]
        @api_current_user.completed_todos
      else
        paginate(@api_current_user.todos)
      end
    render_json(todos: @todos)
  end

  def create
    @todo = @api_current_user.todos.new(todo_params)
    if @todo.save
      render_json(
        { todo: @todo, message: I18n.t('resource.created.success', resource: 'Todo') }, :created
      )
    else
      render_json({ errors: @todo.errors.full_messages }, :unprocessable_entity)
    end
  end

  def show
    @todo = @todo.attributes.merge('items' => @todo.items)
    render_json(todo: @todo)
  end

  def update
    if @todo.update(todo_params)
      render_json(
        todo: @todo, message: I18n.t('resource.updated.success', resource: 'Todo')
      )
    else
      render_json({ errors: @todo.errors.full_messages }, :unprocessable_entity)
    end
  end

  def destroy
    if @todo.destroy
      render_json(
        todo: @todo, message: I18n.t('resource.destroyed.success', resource: 'Todo')
      )
    else
      render_json({ errors: @todo.errors.full_messages }, :unprocessable_entity)
    end
  end

  def last_month_todos
    @todos = Todo.last_month_todos_of_user(@api_current_user.id)
    render_json(todos: @todos)
  end

  private

  def todo_params
    params.require(:todo).permit(:title, :description, :user_id,
                                 items_attributes: %i[title is_completed])
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
