require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require 'json'
require 'net/http'
require './models'
require 'dotenv/load'

enable :sessions

helpers do
    def current_user
        User.find_by(id: session[:user])
    end
end

get '/' do
    @posts = Post.all
    erb :index
end

get '/sign_out' do
    session[:user] = nil
    redirect '/'
end

get '/home' do
    erb :home
end

post '/sign_in' do
    user = User.find_by(name: params[:user_name])
    if user && user.authenticate(params[:password])
        session[:user] = user.id
        redirect '/home'
    else
        User.all.each {|x| puts x.name }
        redirect '/'
    end
end

get '/sign_up' do
    erb :sign_up
end

post '/sign_up' do
    @user = User.create(name:params[:user_name],password:params[:password],
    password_confirmation:params[:password_confirmation])
    if @user.persisted?
        session[:user] = @user.id
    end
    redirect '/home'
end

get '/search' do
    erb :search
end

post '/search' do
    uri = URI("https://itunes.apple.com/search")
    uri.query = URI.encode_www_form({
        term: params[:artist],
        country: 'jp',
        media: 'music',
        entity: 'song',
        attribute: 'artistTerm'
    })
    res = Net::HTTP.get_response(uri)
    json = JSON.parse(res.body)
    @results = json["results"]
    erb :search
end

post '/add' do
    current_user.posts.create(name: params[:name],
        artist: params[:artist],
        album: params[:album],
        comment: params[:comment],
        image_url: params[:image_url],
        preview_url: params[:preview_url])
    erb :search
end

get '/favorite/:post_id' do
    current_user.favorites.create(post_id: params[:post_id])
    redirect '/'
end

get '/unfavorite/:post_id' do
    current_user.favorites.find_by(post_id: params[:post_id]).destroy
    redirect '/'
end

get '/edit/:id' do
    @post = Post.find(params[:id])
    erb :edit
end

post '/edit/:id' do
    post = Post.find(params[:id])
    post.comment = params[:comment]
    post.save
    redirect '/home'
end

get '/delete/:id' do
    Post.find(params[:id]).destroy
    redirect '/home'
end

get '/follow/:id' do
    Relationship.create(
        followed_id: User.find(params[:id]).id,
        following_id: current_user.id
        )
    puts User.find(params[:id]).follows
    redirect '/'
end


get '/unfollow/:id' do
    Relationship.find_by(followed_id:params[:id] ,following_id: current_user.id).destroy
    redirect '/'
end

