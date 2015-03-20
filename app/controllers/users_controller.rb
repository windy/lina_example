class UsersController < Lina::ApplicationController
  # def index
  define_action :index, {
    name: 'index',
    description: '',
    params: {
      type: 'object',
      required: [:name],
      properties: {
        name: {
          type: 'string',
          minlength: '5',
        }
      }
    },
    return: {
    }
  } do
    # write code here, It's the same as before
    return { id: 1 }
  end

  # def show
  define_action :show, {
    name: 'show',
    description: '',
    params: {
      type: 'object',
      properties: {
      }
    },
    return: {
    }
  } do
    # write code here, It's the same as before
  end
end
