# frozen_string_literal: true

# items controller
class ItemsController < ApplicationController
  before_action :set_todo
  before_action :set_todo_item, only: %i[show update destroy]

  def index
    @items = paginate(@todo.items)
    render_json(items: @items)
  end

  def create
    @item = @todo.items.new(item_params)
    if @item.save
      render_json(
        { item: @item, message: I18n.t('resource.created.success', resource: 'Item') }, :created
      )
    else
      render_json({ errors: @item.errors.full_messages }, :unprocessable_entity)
    end
  end

  def update
    if @item.update(item_params)
      render_json(
        item: @item, message: I18n.t('resource.updated.success', resource: 'Item')
      )
    else
      render_json({ errors: @item.errors.full_messages }, :unprocessable_entity)
    end
  end

  def destroy
    if @item.destroy
      render_json(
        item: @item, message: I18n.t('resource.destroyed.success', resource: 'Item')
      )
    else
      render_json({ errors: @item.errors.full_messages }, :unprocessable_entity)
    end
  end

  private

  def item_params
    params.require(:item).permit(:title, :is_completed, :todo_id)
  end

  def set_todo
    @todo = Todo.find(params[:todo_id])
    if @todo.user_id == @api_current_user.id
      @todo
    else
      render_json({ message: 'Not authorized' }, :unauthorized)
    end
  end

  def set_todo_item
    @item = @todo.items.find_by(id: params[:id]) if @todo
  end
end
