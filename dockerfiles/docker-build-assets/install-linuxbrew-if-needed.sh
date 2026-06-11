#!/bin/bash
set -e

BREW_ROOT=/home/linuxbrew
BREW_PREFIX=${BREW_ROOT}/.linuxbrew
BREW_REPOSITORY=${BREW_PREFIX}/Homebrew
BREW_BIN=${BREW_PREFIX}/bin/brew
BREW_USER=traquer

if [ -x "${BREW_BIN}" ]; then
  exit 0
fi

printf "\n\033[0;44m---> Installing Linuxbrew in ${BREW_PREFIX}.\033[0m\n"

mkdir -p "${BREW_REPOSITORY}" "${BREW_PREFIX}/bin" "${BREW_PREFIX}/etc" \
         "${BREW_PREFIX}/include" "${BREW_PREFIX}/lib" "${BREW_PREFIX}/sbin" \
         "${BREW_PREFIX}/share" "${BREW_PREFIX}/var"

if [ ! -d "${BREW_REPOSITORY}/.git" ]; then
  git clone --depth=1 https://github.com/Homebrew/brew "${BREW_REPOSITORY}"
fi

ln -sfn ../Homebrew/bin/brew "${BREW_BIN}"

chown -R "${BREW_USER}:${BREW_USER}" "${BREW_ROOT}"

# Initialize Homebrew metadata. Do not fail container startup if this network step fails.
su - "${BREW_USER}" -c "${BREW_BIN} update --force --quiet" || true

printf "\n\033[0;44m---> Linuxbrew available at ${BREW_BIN}.\033[0m\n"
