#!/bin/bash

set -e

url="https://precoscombustiveis.dgeg.gov.pt/api/PrecoComb/PesquisarPostos"
mapsUrl="https://www.google.com/maps/search/?api=1&query="
brand="29" # Galp
gasTypes="2101,2105" # Diesel and Diesel+

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

res=$(curl -sfkSL "${url}?idsTiposComb=${gasTypes}&idMarca=${brand}&qtdPorPagina=999&pagina=1")
if [ -z "$res" ]; then
    echo "ERROR: Could not fetch data from the API."
    exit 1
fi

echo "$res" | jq -r --arg district "$district" --arg city "$city" --arg mapsUrl "$mapsUrl" '
    .resultado
    | map(select(.Distrito == $district and .Municipio == $city))
    | map(.Preco = (.Preco | gsub(" €"; "") | gsub(","; ".") | tonumber))
    | group_by(.Id)
    | map({
        Id: (.[0].Id),
        Name: (.[0].Nome),
        Address: (.[0].Morada),
        Latitude: (.[0].Latitude),
        Longitude: (.[0].Longitude),
        DieselPrice: ((map(select(.Combustivel == "Gasóleo simples")) | if length > 0 then .[0].Preco else null end)),
        DieselPlusPrice: ((map(select(.Combustivel == "Gasóleo especial")) | if length > 0 then .[0].Preco else null end))
    })
    | map(select(.DieselPrice != null or .DieselPlusPrice != null))
    | sort_by(.DieselPlusPrice // .DieselPrice)
    | .[]
    | "\nName:     \(.Name)\nAddress:  \(.Address)\nCity:     \($city)\nLocation: \($mapsUrl)\(.Latitude),\(.Longitude)\nDiesel:   \(.DieselPrice // "-")€\nDiesel+:  \(.DieselPlusPrice // "-")€"
'
