Reactor2::App.controllers :transaction do
  before {content_type :json}
  before :show do
    @transaction = Transaction.get(params[:guid])
  end

  get :index, map: '/api/v1/transactions' do
    @transactions = Transaction.all
    render 'transaction/index'
  end

  get :show, map: '/api/v1/transactions/:guid' do
    render 'transaction/show'
  end

  post :create, map: '/api/v1/transactions' do
    transaction = Transaction.new(JSON.parse(params[:transaction]))
    transaction.guid = ModelsExtensions::Extensions.get_guid
    transaction.user = User.find_in_db(params[:user_guid])
    transaction.put_in_cache if transaction.save
    response_with transaction
  end

  put :update, map: '/api/v1/transactions/:guid' do
    transaction = Transaction.find_in_db(params[:guid])
    if transaction && transaction.update_attributes(JSON.parse(params[:transaction]))
      transaction.delete_from_cache
      transaction.put_in_cache
    end
    response_with transaction
  end

  delete :destroy, map: '/api/v1/transactions/' do
    transaction = Transaction.find_in_db(params[:guid])

    if transaction
      transaction.delete_from_cache
      transaction.destroy
    end
  end
end