#! /usr/bin/env bash

set -eo pipefail

ROOT_UID=0
DEST_DIR=

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  DEST_DIR="/usr/share/icons"
else
  DEST_DIR="$HOME/.local/share/icons"
fi

SRC_DIR="$(cd "$(dirname "$0")" && pwd)"

THEME_NAME=Colloid
THEME_VARIANTS=('' '-Purple' '-Pink' '-Red' '-Orange' '-Yellow' '-Green' '-Teal' '-Grey')
SCHEME_VARIANTS=('' '-Nord' '-Dracula' '-Gruvbox' '-Everforest' '-Catppuccin')
COLOR_VARIANTS=('-Light' '-Dark' '')

themes=()
schemes=()
colors=()

usage() {
cat << EOF
  Usage: $0 [OPTION]...

  OPTIONS:
    -d, --dest DIR          Specify destination directory (Default: $DEST_DIR)
    -n, --name NAME         Specify theme name (Default: $THEME_NAME)
    -s, --scheme VARIANTS   Specify folder colorscheme variant(s) [default|nord|dracula|gruvbox|everforest|catppuccin|all]
    -t, --theme VARIANTS    Specify folder color theme variant(s) [default|purple|pink|red|orange|yellow|green|teal|grey|all] (Default: blue)
    -notint, --notint       Disable Follow ColorSheme for folders on KDE Plasma
    -r, --remove, -u, --uninstall   Remove/Uninstall $THEME_NAME icon themes
    -h, --help              Show help
EOF
}

# Modificar la función install() para solo copiar iconos de aplicaciones
install() {
  local dest=${1}
  local name=${2}
  local theme=${3}
  local scheme=${4}
  local color=${5}

  local THEME_DIR=${1}/${2}${3}${4}${5}

  [[ -d "${THEME_DIR}" ]] && rm -rf "${THEME_DIR}"

  echo "Installing '${THEME_DIR}'..."

  mkdir -p "${THEME_DIR}"
  cp -r "${SRC_DIR}"/src/index.theme "${THEME_DIR}"
  sed -i "s/Colloid/${2}${3}${4}${5}/g" "${THEME_DIR}"/index.theme

  if [[ "${color}" == '-Light' ]]; then
    cp -r "${SRC_DIR}"/src/apps "${THEME_DIR}"

    # Omitir la copia de iconos del sistema
    # if [[ "${theme}" == '' && "${scheme}" == '' && "${notint}" == 'true' ]]; then
    #   cp -r "${SRC_DIR}"/notint/*.svg "${THEME_DIR}"/places/scalable
    # fi

    colors_folder

    # Omitir la actualización de colores para iconos del sistema
    # if [[ "${scheme}" != '' || "${theme}" != '' ]]; then
    #   cp -r "${SRC_DIR}"/notint/*.svg "${THEME_DIR}"/places/scalable
    #   sed -i "s/#60c0f0/${theme_color}/g" "${THEME_DIR}"/places/scalable/*.svg
    #   sed -i "s/#60c0f0/${theme_color}/g" "${THEME_DIR}"/apps/scalable/*.svg
    # fi

    cp -r "${SRC_DIR}"/links/* "${THEME_DIR}"
  fi

  if [[ "${color}" == '-Dark' ]]; then
    mkdir -p "${THEME_DIR}"/apps
    cp -r "${SRC_DIR}"/src/apps/{22,symbolic} "${THEME_DIR}"/apps

    # Omitir la copia de iconos del sistema
    # cp -r "${SRC_DIR}"/src/devices/{16,22,24,32,symbolic} "${THEME_DIR}"/devices
    # cp -r "${SRC_DIR}"/src/places/{16,22,24,symbolic} "${THEME_DIR}"/places
    # cp -r "${SRC_DIR}"/src/status/{16,22,24,symbolic} "${THEME_DIR}"/status

    # Omitir la actualización de colores para iconos del sistema
    # sed -i "s/#363636/#dedede/g" "${THEME_DIR}"/{actions,devices,places,status}/{16,22,24}/*.svg
    # sed -i "s/#363636/#dedede/g" "${THEME_DIR}"/{actions,devices}/32/*.svg
    # sed -i "s/#363636/#dedede/g" "${THEME_DIR}"/apps/22/*.svg
    # sed -i "s/#363636/#dedede/g" "${THEME_DIR}"/categories/22/*.svg
    # sed -i "s/#363636/#dedede/g" "${THEME_DIR}"/{actions,apps,categories,devices,emblems,mimetypes,places,status}/symbolic/*.svg

    # Omitir la copia de iconos del sistema
    # cp -r "${SRC_DIR}"/links/actions/{16,22,24,32,symbolic} "${THEME_DIR}"/actions
    # cp -r "${SRC_DIR}"/links/devices/{16,22,24,32,symbolic} "${THEME_DIR}"/devices
    # cp -r "${SRC_DIR}"/links/places/{16,22,24,symbolic} "${THEME_DIR}"/places
    # cp -r "${SRC_DIR}"/links/status/{16,22,24,symbolic} "${THEME_DIR}"/status
    # cp -r "${SRC_DIR}"/links/apps/{22,symbolic} "${THEME_DIR}"/apps
    # cp -r "${SRC_DIR}"/links/categories/{22,symbolic} "${THEME_DIR}"/categories
    # cp -r "${SRC_DIR}"/links/mimetypes/symbolic "${THEME_DIR}"/mimetypes

    cd "${dest}"
    # Omitir la creación de enlaces simbólicos para iconos del sistema
    # ln -sf ../../"${name}${theme}${scheme}"-Light/apps/scalable "${name}${theme}${scheme}"-Dark/apps/scalable
    # ln -sf ../../"${name}${theme}${scheme}"-Light/devices/scalable "${name}${theme}${scheme}"-Dark/devices/scalable
    # ln -sf ../../"${name}${theme}${scheme}"-Light/places/scalable "${name}${theme}${scheme}"-Dark/places/scalable
    # ln -sf ../../"${name}${theme}${scheme}"-Light/categories/32 "${name}${theme}${scheme}"-Dark/categories/32
    # ln -sf ../../"${name}${theme}${scheme}"-Light/emblems/16 "${name}${theme}${scheme}"-Dark/emblems/16
    # ln -sf ../../"${name}${theme}${scheme}"-Light/emblems/22 "${name}${theme}${scheme}"-Dark/emblems/22
    # ln -sf ../../"${name}${theme}${scheme}"-Light/status/32 "${name}${theme}${scheme}"-Dark/status/32
    # ln -sf ../../"${name}${theme}${scheme}"-Light/mimetypes/scalable "${name}${theme}${scheme}"-Dark/mimetypes/scalable
  fi

  if [[ "${color}" == '' ]]; then
    cd ${dest}
    ln -sf ../"${name}${theme}${scheme}"-Light/apps "${name}${theme}${scheme}"/apps
    # Omitir la creación de enlaces simbólicos para iconos del sistema
    # ln -sf ../"${name}${theme}${scheme}"-Light/actions "${name}${theme}${scheme}"/actions
    # ln -sf ../"${name}${theme}${scheme}"-Light/devices "${name}${theme}${scheme}"/devices
    # ln -sf ../"${name}${theme}${scheme}"-Light/emblems "${name}${theme}${scheme}"/emblems
    # ln -sf ../"${name}${theme}${scheme}"-Light/places "${name}${theme}${scheme}"/places
    # ln -sf ../"${name}${theme}${scheme}"-Light/categories "${name}${theme}${scheme}"/categories
    # ln -sf ../"${name}${theme}${scheme}"-Light/mimetypes "${name}${theme}${scheme}"/mimetypes
    # ln -sf ../"${name}${theme}${scheme}"-Dark/status "${name}${theme}${scheme}"/status
  fi

  (
    cd "${THEME_DIR}"
    ln -sf actions actions@2x
    ln -sf apps apps@2x
    # Omitir la creación de enlaces simbólicos para iconos del sistema
    # ln -sf categories categories@2x
    # ln -sf devices devices@2x
    # ln -sf emblems emblems@2x
    # ln -sf mimetypes mimetypes@2x
    # ln -sf places places@2x
    # ln -sf status status@2x
  )

  gtk-update-icon-cache "${THEME_DIR}"
}

# Modificar la función colors_folder() para solo aplicar colores a los iconos de aplicaciones
colors_folder() {
  case "$theme" in
    '')
      theme_color='#5b9bf8'
      ;;
    -Purple)
      theme_color='#BA68C8'
      ;;
    -Pink)
      theme_color='#F06292'
      ;;
    -Red)
      theme_color='#F44336'
      ;;
    -Orange)
      theme_color='#FB8C00'
      ;;
    -Yellow)
      theme_color='#FFD600'
      ;;
    -Green)
      theme_color='#66BB6A'
      ;;
    -Teal)
      theme_color='#4DB6AC'
      ;;
    -Grey)
      theme_color='#888888'
      ;;
  esac

  if [[ "$scheme" == '-Nord' ]]; then
    case "$theme" in
      '')
        theme_color='#89a3c2'
        ;;
      -Purple)
        theme_color='#c89dbf'
        ;;
      -Pink)
        theme_color='#dc98b1'
        ;;
      -Red)
        theme_color='#d4878f'
        ;;
      -Orange)
        theme_color='#dca493'
        ;;
      -Yellow)
        theme_color='#eac985'
        ;;
      -Green)
        theme_color='#a0c082'
        ;;
      -Teal)
        theme_color='#83b9b8'
        ;;
      -Grey)
        theme_color='#757a99'
        ;;
    esac
  fi

  if [[ "$scheme" == '-Dracula' ]]; then
    case "$theme" in
      '')
        theme_color='#6272a4'
        ;;
      -Purple)
        theme_color='#bd93f9'
        ;;
      -Pink)
        theme_color='#ff79c6'
        ;;
      -Red)
        theme_color='#ff5555'
        ;;
      -Orange)
        theme_color='#ffb86c'
        ;;
      -Yellow)
        theme_color='#f1fa8c'
        ;;
      -Green)
        theme_color='#50fa7b'
        ;;
      -Teal)
        theme_color='#50fae9'
        ;;
      -Grey)
        theme_color='#757a99'
        ;;
    esac
  fi

  if [[ "$scheme" == '-Gruvbox' ]]; then
    case "$theme" in
      '')
        theme_color='#83a598'
        ;;
      -Purple)
        theme_color='#d386cd'
        ;;
      -Pink)
        theme_color='#d3869b'
        ;;
      -Red)
        theme_color='#fb4934'
        ;;
      -Orange)
        theme_color='#fe8019'
        ;;
      -Yellow)
        theme_color='#fabd2f'
        ;;
      -Green)
        theme_color='#b8bb26'
        ;;
      -Teal)
        theme_color='#8ec07c'
        ;;
      -Grey)
        theme_color='#868686'
        ;;
    esac
  fi

  if [[ "$scheme" == '-Everforest' ]]; then
    case "$theme" in
      '')
        theme_color='#7fbbb3'
        ;;
      -Purple)
        theme_color='#D699B6'
        ;;
      -Pink)
        theme_color='#d3869b'
        ;;
      -Red)
        theme_color='#E67E80'
        ;;
      -Orange)
        theme_color='#E69875'
        ;;
      -Yellow)
        theme_color='#DBBC7F'
        ;;
      -Green)
        theme_color='#A7C080'
        ;;
      -Teal)
        theme_color='#83C092'
        ;;
      -Grey)
        theme_color='#7a8478'
        ;;
    esac
  fi

  if [[ "$scheme" == '-Catppuccin' ]]; then
    case "$theme" in
      '')
        theme_color='#8caaee'
        ;;
      -Purple)
        theme_color='#ca9ee6'
        ;;
      -Pink)
        theme_color='#f4b8e4'
        ;;
      -Red)
        theme_color='#ea999c'
        ;;
      -Orange)
        theme_color='#fe8019'
        ;;
      -Yellow)
        theme_color='#ef9f76'
        ;;
      -Green)
        theme_color='#a6d189'
        ;;
      -Teal)
        theme_color='#81c8be'
        ;;
      -Grey)
        theme_color='#7c7f93'
        ;;
    esac
  fi
}

# Modificar la función install_theme() para solo instalar iconos de aplicaciones
install_theme() {
  for theme in "${themes[@]}"; do
    for scheme in "${schemes[@]}"; do
      for color in "${colors[@]}"; do
        install "${dest:-${DEST_DIR}}" "${name:-${THEME_NAME}}" "${theme}" "${scheme}" "${color}"
      done
    done
  done
}

# Mantener las funciones remove_theme() y clean_old_theme() sin cambios

# Ejecutar las funciones correspondientes
clean_old_theme

if [[ "${remove}" == 'true' ]]; then
  remove_theme
else
  install_theme
fi

echo -e "\nFinished!\n"
