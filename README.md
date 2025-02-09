# kenken-poke-remix

**kenken-poke-remix** は、Remix（TypeScript/tsx）とTailwind CSSを用いて実装されたモダンなフルスタックアプリケーションです。  
このアプリは、[pokeapi.co](https://pokeapi.co) からPokemonのデータを取得し、地域別の一覧表示や詳細画面、さらにお気に入り機能（現時点ではダミー実装、後にCloud Spanner連携へ）を提供します。  
また、レイヤードアーキテクチャおよび依存性注入（DIコンテナ：tsyringe）を採用しており、テスタビリティと拡張性の高い設計となっています。

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Directory Structure](#directory-structure)
- [Setup and Development](#setup-and-development)
- [Dockerization](#dockerization)
- [Deployment to GKE](#deployment-to-gke)
- [CI/CD](#cicd)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)

## Overview
**kenken-poke-remix** は、ユーザーに地域ごとのPokemon一覧や各Pokemonの詳細情報、お気に入り登録機能を提供するアプリケーションです。  
RemixのSSRやルーティング機能を活用し、SEO対策や初回ロードの高速化を実現するとともに、最新のフロントエンド技術に則った洗練されたUIを提供します。

## Features
- **地域別Pokemon一覧**  
  タブによる地域選択で、カントー、ジョウトなどの各地方のPokemon一覧を表示。
- **Pokemon詳細画面**  
  各Pokemonの写真、図鑑番号、説明などを詳細に表示し、お気に入りボタンで操作可能。
- **お気に入り管理**  
  お気に入り登録・削除が可能。現時点ではInMemory実装ですが、将来的にCloud Spannerとの連携を実現予定。
- **レスポンシブかつモダンなUI**  
  Tailwind CSSを利用し、モバイル対応・マテリアルデザインに沿った角丸表示などを実装。
- **テスタビリティと品質管理**  
  ESLint、Prettier、Vitestによるコード品質および自動テスト環境を整備。

## Technology Stack
- **Framework**: [Remix](https://remix.run)
- **Language**: TypeScript / TSX
- **Styling**: Tailwind CSS
- **DI Container**: tsyringe
- **HTTP Client**: axios
- **Testing**: Vitest, ESLint, Prettier
- **Containerization**: Docker
- **Deployment**: Google Kubernetes Engine (GKE)

## Directory Structure
```
kenken-poke-remix/
├── app/
│   ├── components/         # UIコンポーネント（PokemonCard, Tabs, FavoriteButton等）
│   ├── di/                 # DIコンテナ設定（tsyringeを利用）
│   ├── domain/             # ドメインモデル、リポジトリ（FavoriteRepositoryなど）
│   ├── routes/             # Remixルート（一覧、詳細、APIエンドポイント等）
│   ├── services/           # サービス層（PokemonService, FavoriteService）
│   ├── session.server.ts   # Cookie/Session管理用
│   ├── entry.client.tsx    # クライアントエントリーポイント
│   ├── entry.server.tsx    # サーバーエントリーポイント
│   ├── root.tsx            # ルートコンポーネント（HTML共通部分）
│   └── styles/             # Tailwind CSSスタイルシート
├── .eslintrc.js            # ESLint設定
├── .prettierrc             # Prettier設定
├── Dockerfile              # Dockerコンテナ化用設定
├── docker-compose.yml      # 必要に応じたdocker-compose設定
├── package.json            # npmスクリプトおよび依存関係
├── postcss.config.js       # PostCSS設定
├── remix.config.js         # Remixアプリ設定
├── tailwind.config.js      # Tailwind CSS設定
├── tsconfig.json           # TypeScript設定
├── vitest.config.ts        # Vitestテスト設定
└── .github/
    └── workflows/
        └── ci-cd.yml       # GitHub Actions CI/CDパイプライン設定
```

## Setup and Development

### Prerequisites
- Node.js v18 以降
- Yarn または npm
- Docker（コンテナ化テスト用）
- Git

### Installation
1. リポジトリをクローンします：
   ```bash
   git clone https://github.com/yourusername/kenken-poke-remix.git
   cd kenken-poke-remix
   ```
2. 依存関係をインストールします：
   ```bash
   yarn install
   # または: npm install
   ```
3. 開発サーバーを起動します：
   ```bash
   yarn dev
   # または: npm run dev
   ```
4. ブラウザで [http://localhost:3000](http://localhost:3000) を確認してください。

## Dockerization

### Dockerイメージのビルド
プロジェクトルートに配置したDockerfileを用いて、以下のコマンドでビルドします：
```bash
docker build -t kenken-poke-remix:latest .
```

### ローカルでのDocker実行
ビルドしたイメージをローカルで実行するには：
```bash
docker run -p 3000:3000 kenken-poke-remix:latest
```
ブラウザで [http://localhost:3000](http://localhost:3000) にアクセスし、アプリの動作を確認してください。

## Deployment to GKE

### コンテナレジストリへのプッシュ
1. GCPのContainer Registry（またはArtifact Registry）に認証します：
   ```bash
   gcloud auth login
   gcloud config set project [YOUR_PROJECT_ID]
   gcloud auth configure-docker
   ```
2. Dockerイメージにタグ付けし、プッシュします：
   ```bash
   docker tag kenken-poke-remix:latest gcr.io/[YOUR_PROJECT_ID]/kenken-poke-remix:latest
   docker push gcr.io/[YOUR_PROJECT_ID]/kenken-poke-remix:latest
   ```

### Kubernetesマニフェストの適用
GKEクラスタにデプロイするため、以下のマニフェストファイル（例：`deployment.yaml` と `service.yaml`）を作成し、適用します。

#### Deployment例 (`deployment.yaml`)
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kenken-poke-remix
  labels:
    app: kenken-poke-remix
spec:
  replicas: 3
  selector:
    matchLabels:
      app: kenken-poke-remix
  template:
    metadata:
      labels:
        app: kenken-poke-remix
    spec:
      containers:
      - name: kenken-poke-remix
        image: gcr.io/[YOUR_PROJECT_ID]/kenken-poke-remix:latest
        ports:
        - containerPort: 3000
        env:
        - name: NODE_ENV
          value: "production"
```

#### Service例 (`service.yaml`)
```yaml
apiVersion: v1
kind: Service
metadata:
  name: kenken-poke-remix-service
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 3000
    protocol: TCP
  selector:
    app: kenken-poke-remix
```

適用は以下のコマンドで行います：
```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```
外部IPが割り当てられたら、アプリの動作を確認してください。

## CI/CD
このプロジェクトではGitHub Actionsを用いて、以下を自動化しています：
- **Lint/フォーマットチェック**（ESLint/Prettier）
- **テストの実行**（Vitest）
- **Dockerイメージのビルドとプッシュ**
- **TerraformのCI/CD**（別リポジトリまたは同一リポジトリ内のGCPインフラコードとの連携）
  
詳細は `.github/workflows/ci-cd.yml` を参照してください。必要なシークレット（GCP認証情報、環境変数など）はGitHubリポジトリのSettingsで設定してください。

## Testing
ローカルでテストは以下のコマンドで実行できます：
```bash
yarn test
# または: npm run test
```
ESLint、Prettierのチェックも実施してください：
```bash
yarn lint
yarn format
```

## Contributing
改善提案、バグ報告など大歓迎です。  
まずはIssueを立て、Pull Requestを送っていただく形でご協力ください。

## License
[MIT License](LICENSE)
