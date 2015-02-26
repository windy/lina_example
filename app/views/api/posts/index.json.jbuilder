json.array! @posts do |post|
  json.extract! post, :id, :name, :created_at
end
