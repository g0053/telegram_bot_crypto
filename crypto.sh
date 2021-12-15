#!/bin/bash
TG_USERID="CHAT_ID_or_USER_ID"
tg_bot_key="TELEGRAM_API_KEY"
tg_bot_url="https://api.telegram.org/bot$tg_bot_key/sendMessage"
CMP_API="https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest"
API_KEY="COIN_API_KEY"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
NC='\033[0m'
bold=$(tput bold)
normal=$(tput sgr0)

while true
do 
        #Coin - General status
        btc_json="$(curl -s -H "X-CMC_PRO_API_KEY: $API_KEY" -H "Accept: application/json" -d "slug=bitcoin&convert=USD" -G ${CMP_API})"
        if [ ! "$btc_json" == "" ]; then
                btc_price="$(echo "${btc_json}" | jq '.data."1".quote.USD.price')"
                echo "$btc_price"
                btc_1h="$(echo "${btc_json}" | jq '.data."1".quote.USD.percent_change_1h')"
                btc_24h="$(echo "${btc_json}" | jq '.data."1".quote.USD.percent_change_24h')"
                #POSITIVE OR NEGATIVE TENDENCY
                if (( $(echo "$btc_1h >= 0.0" | bc -l) )); then
                        btc_1h_colour="${GREEN}" 

                else
                        btc_1h_colour="${RED}"
                fi

                if (( $(echo "$btc_24h >= 0.0" | bc -l) )); then
                        btc_24h_colour="${GREEN}"
                else
                        btc_24h_colour="${RED}"
                fi

                btc_data="* ${BLUE}${bold}BTC-USD:${NC} ${WHITE}${btc_price}${NC}${normal} USD (${btc_1h_colour}${bold}${btc_1h}%${NC} 1H; ${btc_24h_colour}${bold}${btc_24h}%${NC} 24H) $(date)"
                btc_data_tg="* BTC-USD: ${btc_price} USD (${btc_1h}% 1H; ${btc_24h}% 24H) $(date)"
                echo -e "$btc_data"
                curl -s --max-time 10 -d "chat_id=${TG_USERID}&disable_web_page_preview=1&text=${btc_data_tg}" ${tg_bot_url}  > /dev/null

        else
                echo -e "* ${BLUE}BTC-USD:${NC} No data available $(date)"

        fi
        #sleep 1800 #WAIT 30 MINUTES
        sleep 60
done
