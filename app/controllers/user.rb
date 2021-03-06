Reactor2::App.controllers :user do
  before {content_type :json}
  before :show do
    @user = User.get(params[:guid])
  end

  get :index, map: '/api/v1/users' do
    @users = User.all
    render 'user/index'
  end

  get :show, map: '/api/v1/users/:guid' do
    render 'user/show'
  end

  post :create, map: '/api/v1/users' do
    user = User.new(JSON.parse(params[:user]))
    user.guid = ModelsExtensions::Extensions.get_guid
    user.put_in_cache if user.save
    response_with user
  end

  put :update, map: '/api/v1/users/:guid' do
    user = User.find_in_db(params[:guid])
    if user && user.update_attributes(JSON.parse(params[:user]))
      user.delete_from_cache
      user.put_in_cache
    end
    response_with user
  end

  delete :destroy, map: '/api/v1/users/' do
    user = User.find_in_db(params[:guid])

    if user
      user.delete_from_cache
      user.destroy
      response_with user, 'The User can not be deleted!'
    end
  end
end
