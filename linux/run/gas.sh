#!/system/bin/sh

set -e

url="https://precoscombustiveis.dgeg.gov.pt/api/PrecoComb/PesquisarPostos"
mapsUrl="https://www.google.com/maps/search/?api=1&query="
gasType="2105" # Diesel+
brand="29" # Galp

listPrices() {
    res2=$(echo "$res" | jq -r --arg district "$1" --arg city "$2" --arg mapsUrl "$mapsUrl" '.resultado
    | map(.Preco = (.Preco | gsub(" €"; "") | gsub(","; ".") | tonumber))
    | map(select(.Distrito == $district and .Municipio == $city))
    | group_by(.Municipio)
    | .[] | sort_by(.Preco)[:3][]
    | "Name:     \(.Nome)\nAddress:  \(.Morada)\nCity:     \($city)\nLocation: \($mapsUrl)\(.Latitude),\(.Longitude)\nPrice:    \(.Preco)€\n"')
    if [ ! -z "$res2" ]; then
        echo "$res2"
    else
        echo "No results found for $1, $2"
    fi
}

res=$(curl -sfkSL "${url}?idsTiposComb=${gasType}&idMarca=${brand}&qtdPorPagina=999&pagina=1")
if [ ! -z "$1" ] && [ ! -z "$2" ]; then
    listPrices "$1" "$2"
elif [ ! -z "$1" ]; then
    listPrices "Porto" "$1"
else
    listPrices "Porto" "Maia"
    listPrices "Porto" "Matosinhos"
    listPrices "Porto" "Porto"
    listPrices "Porto" "Vila do Conde"
fi
