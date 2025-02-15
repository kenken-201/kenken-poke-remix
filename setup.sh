# 必要ディレクトリ作成
mkdir -p app/{components,di,domain/models,domain/repositories,routes/api,services,styles}
mkdir -p .github/workflows

# 各ファイル作成（例）
touch package.json tsconfig.json remix.config.js postcss.config.js tailwind.config.js .eslintrc.js .prettierrc vitest.config.ts Dockerfile docker-compose.yml
touch .github/workflows/ci-cd.yml
touch app/entry.client.tsx app/entry.server.tsx app/root.tsx app/session.server.ts
touch app/routes/index.tsx app/routes/pokemons.$pokemonId.tsx app/routes/favorites.tsx
touch app/routes/api/pokemons.ts app/routes/api/favorites.ts
touch app/components/PokemonCard.tsx app/components/PokemonTabs.tsx app/components/FavoriteButton.tsx
touch app/services/PokemonService.ts app/services/FavoriteService.ts
touch app/domain/models/Pokemon.ts app/domain/models/User.ts
touch app/domain/repositories/FavoriteRepository.ts app/domain/repositories/InMemoryFavoriteRepository.ts
touch app/di/container.ts
touch app/styles/tailwind.css
