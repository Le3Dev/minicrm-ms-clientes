#!/usr/bin/env bash
# Cadastra clientes de exemplo pela API (útil antes de gravar o vídeo).
# Uso: BASE_URL=https://<ms-clientes> ./scripts/seed.sh     (padrão: http://localhost:8080)
set -euo pipefail
BASE_URL="${BASE_URL:-http://localhost:8080}"
cadastrar() {
  # O corpo vai pela entrada padrão, em UTF-8 puro: no Git Bash do Windows, passar acentos
  # direto em -d faz o curl enviar outra codificação e o servidor responde 400.
  local corpo resposta
  corpo=$(printf '{"nome":"%s","empresa":"%s","email":"%s","telefone":"%s","responsavelId":"%s"}' "$1" "$2" "$3" "$4" "$5")
  resposta=$(printf '%s' "$corpo" | curl -sS -w '\n%{http_code}' -X POST "$BASE_URL/clientes" \
    -H 'content-type: application/json; charset=utf-8' --data-binary @-)
  local codigo="${resposta##*$'\n'}"
  if [ "$codigo" != "201" ] && [ "$codigo" != "200" ]; then
    echo "✘ $1: HTTP $codigo — ${resposta%$'\n'*}" >&2
    return 1
  fi
  echo "✔ $1 ($2)"
}
cadastrar "Mariana Souza"   "Acme Ltda"          "mariana@acme.com.br"     "(41) 99811-2030" "u2"
cadastrar "João Pereira"    "Café Brasil"        "joao@cafebrasil.com"     "(41) 99722-1144" "u2"
cadastrar "Ana Lima"        "Lima Engenharia"    "ana@limaeng.com.br"      "(11) 98123-4567" "u5"
cadastrar "Bruno Alves"     "TechSul Sistemas"   "bruno@techsul.com"       "(51) 99654-3210" "u5"
cadastrar "Carla Mendes"    "Mendes Logística"   "carla@mendeslog.com.br"  "(41) 99900-1122" "u1"
cadastrar "Diego Ramos"     "Ramos & Filhos"     "diego@ramosfilhos.com"   "(21) 99777-8899" "u2"
cadastrar "Fernanda Castro" "Castro Alimentos"   "fernanda@castro.com.br"  "(31) 98888-0001" "u5"
cadastrar "Gustavo Prado"   "Prado Construtora"  "gustavo@prado.com.br"    "(41) 99101-2020" "u1"
