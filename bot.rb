require 'rubygems'
require 'telegram/bot'
require 'net/http'
require 'json'

# username - bot name = allcodeneobot
# botname = neo-bot
# token ='522356412:AAFtFZK_ANvlq6JIH17pGneDAf3pn8jErbY'
# start command = bundle exec ruby bot.rb
# public group = @allcodeneo, bot is a group admin

crypto_currency_data_url = 'https://api.coinmarketcap.com/v1/ticker/?convert=USD'
telegram_channel_ids = ['509170903', '@allcodeneo', '-1001155467764']
telegram_token = '522356412:AAFtFZK_ANvlq6JIH17pGneDAf3pn8jErbY'
number_of_minutes = 15

Telegram::Bot::Client.run(telegram_token, logger: Logger.new($stderr)) do |bot|

  bot.logger.info('Bot has been started')

  while true do

    # Get Data
    uri = URI.parse(crypto_currency_data_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    @crypto_currency_data = http.get(uri.request_uri)

    if @crypto_currency_data.code == "200"

      # Parse response
      @crypto_currency_data = JSON.parse(@crypto_currency_data.body)

      neo = @crypto_currency_data.select{|cc| cc['id'] == 'neo'}[0]
      neo_value = sprintf('$ %.3f', neo['price_usd'])

      bitcoin = @crypto_currency_data.select{|cc| cc['id'] == 'bitcoin'}[0]
      bitcoin_value = sprintf('$ %.3f', bitcoin['price_usd'])

      ethereum = @crypto_currency_data.select{|cc| cc['id'] == 'ethereum'}[0]
      ethereum_value = sprintf('$ %.3f', ethereum['price_usd'])

      telegram_channel_ids.each do |id|

        bot.logger.info("Send Message to #{id}, BTC: USD #{bitcoin_value}   NEO: USD #{neo_value}   ETH: USD #{ethereum_value}")

        bot.api.send_message(chat_id: id, text: "BTC: USD #{bitcoin_value}   NEO: USD #{neo_value}   ETH: USD #{ethereum_value}" )

      end
    end

    sleep 60 * number_of_minutes
  end

end