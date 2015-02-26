class Api::PostsController < Lina::ApplicationController
  # def index
  define_action :index, {
    name: '获取所有文章',
    description: '这个接口用来获取所有文章, 参数及返回值请见下文',
    params: {
      properties: {
        created_order_by: {
          enum: [ :asc, :desc ],
          description: '按创建时间正序或倒序排'
        }
      }
    },
    return: {
      type: 'array',
      items: {
        type: 'object',
        required: [:id, :name, :created_at],
        properties: {
          id: {
            type: 'integer',
            description: '文章ID',
          },
          name: {
            type: 'string',
            description: '文章标题',
          },
          created_at: {
            type: 'string',
            description: '创建时间, 格好的字符串'
          }
        }
      }
    }
  } do
    @posts = Post.all
  end

  # def show
  define_action :show, {
    name: '获取某一篇文章的内容',
    description: '',
    params: {
      type: 'object',
      required: [:id],
      properties: {
        id: {
          type: 'string',
        }
      }
    },
    return: {
      type: 'object',
      description: '返回文章详情',
      required: [:id, :name, :content, :created_at],
      properties: {
        id: { type: 'integer' },
        name: { type: 'string' },
        content: { type: 'string' },
        created_at: { type: 'string' },
      }
    }
  } do
    @post = Post.find(params[:id])
  end
end
