#!/system/bin/sh

set -e

if [ ! -z "$1" ] && [ ! -z "$2" ]; then
    district="$1"
    city="$2"
elif [ ! -z "$1" ]; then
    district="Porto"
    city="$1"
else
    district="Porto"
    city="Maia"
fi

url="https://precoscombustiveis.dgeg.gov.pt/api/PrecoComb/PesquisarPostos"
mapsUrl="https://www.google.com/maps/search/?api=1&query="
brand="29" # Galp
regularDieselID="2101" # Regular Diesel
premiumDieselID="2105" # Diesel+

fetchPrices() {
    curl -sfkSL "${url}?idsTiposComb=${1}&idMarca=${brand}&qtdPorPagina=999&pagina=1"
}

res_regular=$(fetchPrices "$regularDieselID")
regular_data=$(echo "$res_regular" | jq -r --arg district "$district" --arg city "$city" '
    .resultado 
    | map(select(.Distrito == $district and .Municipio == $city))
    | map({
        key: (.Id | tostring),
        value: {
            "regularPrice": (.Preco | gsub(" €"; "") | gsub(","; ".") | tonumber),
            "Nome": .Nome,
            "Morada": .Morada,
            "Latitude": .Latitude,
            "Longitude": .Longitude
        }
    })
    | from_entries
')

res_premium=$(fetchPrices "$premiumDieselID")
premium_data=$(echo "$res_premium" | jq -r --arg district "$district" --arg city "$city" '
    .resultado 
    | map(select(.Distrito == $district and .Municipio == $city))
    | map({
        key: (.Id | tostring),
        value: {
            "premiumPrice": (.Preco | gsub(" €"; "") | gsub(","; ".") | tonumber)
        }
    })
    | from_entries
')

if [ -z "$regular_data" ] || [ -z "$premium_data" ]; then
    echo "ERROR: Could not fetch data for one or both fuel types."
    exit 1
fi

echo "$regular_data" "$premium_data" | jq -r -s --arg mapsUrl "$mapsUrl" --arg city "$city" '
    .[0] * .[1]
    | to_entries 
    | map(.value) 
    | sort_by(.premiumPrice)[]
    | "\nName:     \(.Nome)\nAddress:  \(.Morada)\nCity:     \($city)\nLocation: \($mapsUrl)\(.Latitude)%2C\(.Longitude)\nDiesel:   \(.regularPrice)€\nDiesel+:  \(.premiumPrice)€"
'
