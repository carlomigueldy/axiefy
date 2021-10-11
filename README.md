# axiefy

An open-source software that aims to help primarily on NFT Game Managers of Axie Infinity in order for them to conveniently manage and track their scholars, while also being an entry to Supabase's 2nd Hackathon "Supabase Hacktoberfest Hackathon 2021". We are also interested in building features not only suitable for Managers, but for the player base as a whole (e.g like Breeding). Currently the App enables manager to invite their Scholars to the app (making it so that the scholars are the one inputing their ronin address) and oversee their performance like total SLP farmed and PVP Rankings

## Axie Infinity

Axie Infinity is a Pokémon-inspired universe where anyone can earn tokens through skilled gameplay and contributions to the ecosystem. Players can battle, collect, raise, and build a land-based kingdom for their pets. (https://whitepaper.axieinfinity.com/)

## Motivation/Ideas

On our brain storming phase, we aim to build an app that has both Web2 and Web3 element inside it. However, we couldn't seem to think of anything at that time until we thought about building an App within Axie Infinity ecosystem, since it is one of the most popular blockchain related game in the Web3 environment. But we couldn't find any docs regarding Ronin Wallet, which is an Ethereum side chain governing Axie Ecosystem. Thus for now, we are only creating an app focuses on giving convenience to the interactions between Managers and their Scholars.

## Demo

App: [https://axiefy.vercel.app/](https://axiefy.vercel.app/)

Credentials:
- email: carlomigueldy@gmail.com
- password: password

### Screenshots

![image](https://user-images.githubusercontent.com/45052332/136729864-dc64852d-11e0-4b2c-8a35-3cbddcff7804.png)

![image](https://user-images.githubusercontent.com/45052332/136729891-a4573b37-9056-435e-a613-30ffe65648e3.png)

![image](https://user-images.githubusercontent.com/45052332/136729925-bc8c9774-8999-4d3c-ade3-27385da73607.png)

## Supabase Hacktoberfest 2021 Team Members ⚡

- Captain 👑 [Carlo Miguel Dy](https://twitter.com/CarloMiguelDy)
- [Ali Asgar L. Laut](https://twitter.com/AliiiLucmanLaut)

## Supabase Usage

- Used for storing data
- Used RLS to prevent unauthorized actions (Current there's a bug we can't figure out in the given time 🐞) 
- Used authentication, magic link, email and password, and OAuth 2.0 providers
- Used storage for photo uploads

## Setup Development Environment

Copy `.env.example` file

```bash
$ cp .env.example .env
```

Open file `.env` and put key and secret

```
SUPABASE_KEY=<SUPABASE_KEY>
SUPABASE_URL=<SUPABASE_URL>
```

Install dependencies

```bash
npm i
```

Run dev server

```bash
npm run dev
```

## Contributing

Be in `main` branch

```bash
$ git checkout main
```

Branch out from `main` by the following command

```bash
$ git checkout -b <your-branch-name> # git checkout -b feature/some-cool-feature
```

Then push upstream the latest branch

```bash
$ git push -u origin <your-branch-name> # git push -u origin feature/some-cool-feature
```

You can then stage all your changes

```bash
$ git add .
```

And push them to the branch you created

```bash
$ git push
```

And finally, create a Pull Request from the repository.

Switch back to `main` branch or any branch you desire.

```bash
$ git checkout main # git checkout <branch-name>
```

## Build Setup

```bash
# install dependencies
$ npm install

# serve with hot reload at localhost:3000
$ npm run dev

# build for production and launch server
$ npm run build
$ npm run start

# generate static project
$ npm run generate
```

For detailed explanation on how things work, check out the [documentation](https://nuxtjs.org).

## Special Directories

You can create the following extra directories, some of which have special behaviors. Only `pages` is required; you can delete them if you don't want to use their functionality.

### `assets`

The assets directory contains your uncompiled assets such as Stylus or Sass files, images, or fonts.

More information about the usage of this directory in [the documentation](https://nuxtjs.org/docs/2.x/directory-structure/assets).

### `components`

The components directory contains your Vue.js components. Components make up the different parts of your page and can be reused and imported into your pages, layouts and even other components.

More information about the usage of this directory in [the documentation](https://nuxtjs.org/docs/2.x/directory-structure/components).

### `layouts`

Layouts are a great help when you want to change the look and feel of your Nuxt app, whether you want to include a sidebar or have distinct layouts for mobile and desktop.

More information about the usage of this directory in [the documentation](https://nuxtjs.org/docs/2.x/directory-structure/layouts).

### `pages`

This directory contains your application views and routes. Nuxt will read all the `*.vue` files inside this directory and setup Vue Router automatically.

More information about the usage of this directory in [the documentation](https://nuxtjs.org/docs/2.x/get-started/routing).

### `plugins`

The plugins directory contains JavaScript plugins that you want to run before instantiating the root Vue.js Application. This is the place to add Vue plugins and to inject functions or constants. Every time you need to use `Vue.use()`, you should create a file in `plugins/` and add its path to plugins in `nuxt.config.js`.

More information about the usage of this directory in [the documentation](https://nuxtjs.org/docs/2.x/directory-structure/plugins).

### `static`

This directory contains your static files. Each file inside this directory is mapped to `/`.

Example: `/static/robots.txt` is mapped as `/robots.txt`.

More information about the usage of this directory in [the documentation](https://nuxtjs.org/docs/2.x/directory-structure/static).

### `store`

This directory contains your Vuex store files. Creating a file in this directory automatically activates Vuex.

More information about the usage of this directory in [the documentation](https://nuxtjs.org/docs/2.x/directory-structure/store).

## Contributors

Thanks for all these wonderful people.

- [Carlo Miguel Dy](https://twitter.com/CarloMiguelDy)
- [Ali Asgar Laut](https://twitter.com/AliiiLucmanLaut)
- Add your name here!

## Acknowledgements

No one here yet. Want your name to be added? Hit me up! We probably need some cool logo. 😉

## Author

- [Carlo Miguel Dy](https://twitter.com/CarloMiguelDy)
- [Ali Asgar Laut](https://twitter.com/AliiiLucmanLaut)
