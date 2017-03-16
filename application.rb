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
      when 'Media'
        erb :'modules/media', locals: { media: connectable }
      when 'Attachment'
        erb :'modules/attachment', locals: { attachment: connectable }
      when 'Link'
        erb :'modules/link', locals: { link: connectable }
      else
        erb :'modules/generic', locals: { block: connectable }
      end
    end

    def get(channel_id)
      channel = Arena.channel(channel_id)

      unless (channel.user_id == ENV['ARENA_OWNER_ID'].to_i) && channel.published
        halt 403, 'Forbidden'
      end

      channel
    end
  end

  get '/' do
    @channel = get(ENV['ARENA_ROOT_CHANNEL_ID'])
    erb :index, layout: :layout
  end

  get '/:channel_id' do
    @channel = get(params[:channel_id])
    erb :index, layout: :layout
  end
end
