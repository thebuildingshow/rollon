class Application < Sinatra::Base
  set :assets_precompile, %w(application.css application.js *.ico *png *.svg *.woff *.woff2)
  set :assets_prefix, %w(assets)
  set :assets_css_compressor, :sass
  set :protection, except: [:frame_options]

  register Sinatra::AssetPipeline

  helpers do
    def channel(connectable)
      erb :'modules/channel', locals: { channel: connectable }
    end

    def block(connectable)
      case connectable._class
      when 'Image'
        erb :'modules/image', locals: { image: connectable }
      when 'Text'
        erb :'modules/text', locals: { text: connectable }
      when 'Attachment'
        erb :'modules/attachment', locals: { attachment: connectable }
      else
        erb :'modules/generic', locals: { block: connectable }
      end
    end
  end

  get '/' do
    @channel = Arena.channel ENV['ARENA_ROOT_CHANNEL_ID']
    erb :home, layout: :layout
  end

  get '/:channel_id' do
    @channel = Arena.channel(params[:channel_id]) # Needs encoding with secret
    erb :index, layout: :layout
  end
end
