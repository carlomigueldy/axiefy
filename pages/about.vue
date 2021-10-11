<template>
  <app-main-container>
    <template v-slot:action>
      <v-btn @click="dialog.review = true" depressed>Feedback</v-btn>
    </template>

    <app-review-dialog v-model="dialog.review" />

    <v-row>
      <v-col>
        <v-card flat outlined>
          <v-card-title>About</v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <p>
              An open-source software that aims to help NFT Game Managers manage
              and track their scholars. While also being an entry to Supabase's
              2nd Hackathon
              <a
                href="https://supabase.io/blog/2021/09/28/supabase-hacktoberfest-hackathon-2021"
                target="_blank"
                class="font-weight-bold"
              >
                "Supabase Hacktoberfest Hackathon 2021"
              </a>
            </p>

            <section class="mb-10 mt-10">
              <div class="subtitle-1 white--text">Author</div>
              <ul style="font-size: 16px">
                <li>
                  <p>
                    <a href="https://github.com/carlomigueldy" target="_blank">
                      carlomigueldy
                    </a>
                    /
                    <a href="https://twitter.com/CarloMiguelDy" target="_blank">
                      @CarloMiguelDy
                    </a>
                  </p>
                </li>
                <li>
                  <p>
                    <a href="https://github.com/sushiAlii" target="_blank">
                      sushiAlii
                    </a>
                    /
                    <a
                      href="https://twitter.com/AliiiLucmanLaut"
                      target="_blank"
                    >
                      AliiiLucmanLaut
                    </a>
                  </p>
                </li>
              </ul>
            </section>

            <section class="mb-10">
              <div class="subtitle-1 white--text">Contributors</div>
              <ul style="font-size: 16px">
                <li>
                  <p>
                    No one have contributed to this project yet. Create a
                    <a
                      href="https://github.com/carlomigueldy/supa"
                      target="_blank"
                    >
                      Pull Request </a
                    >!
                  </p>
                </li>
              </ul>
            </section>

            <section class="mb-10">
              <div class="subtitle-1 white--text">Technology Stack & Usage</div>
              <ul style="font-size: 16px">
                <li>
                  <p>
                    <a href="https://www.postgresql.org/" target="_blank">
                      PostgreSQL </a
                    >: Also known as Postgres, is a free and open-source
                    relational database management system emphasizing
                    extensibility and SQL compliance.
                  </p>
                </li>
                <li>
                  <p>
                    <a href="https://supabase.io/" target="_blank"> Supabase </a
                    >: A serverless PostgreSQL database, also provides
                    zero-boilerplate for authentication and OAuth 2.0
                    integrations
                  </p>
                </li>
                <li>
                  <p>
                    <a href="https://vuejs.org/" target="_blank"> Vue.js </a>: A
                    Progressive JavaScript framework for building UI
                  </p>
                </li>
                <li>
                  <p>
                    <a href="https://nuxtjs.org/" target="_blank"> Nuxt.js </a>:
                    Vue.js framework for seamless app scaffolding and module
                    integrations
                  </p>
                </li>
                <li>
                  <p>
                    <a href="https://vuetifyjs.com/" target="_blank">
                      Vuetify.js </a
                    >: A Vue.js UI library using the Material Design System.
                    Perfect for developers who can't design or know well about
                    UI designs 😜
                  </p>
                </li>
                <li>
                  <p>
                    <a href="https://vercel.com/" target="_blank"> Vercel </a>:
                    Provides us a free static web hosting
                  </p>
                </li>
                <li>
                  <p>
                    <a href="https://github.com/" target="_blank"> GitHub </a>:
                    A platform where we store our code also allowing us to
                    collaborate seamlessly.
                  </p>
                </li>
                <li>
                  <p>
                    <a href="https://aws.amazon.com/lambda/" target="_blank">
                      AWS Lambda </a
                    >: AWS Lambda is an event-driven, serverless computing
                    platform provided by Amazon as a part of Amazon Web
                    Services.
                  </p>
                </li>
              </ul>
            </section>

            <section class="mb-10">
              <div class="subtitle-1 white--text">Bugs / Issues</div>

              <div class="rounded my-5">
                <iframe
                  src="https://giphy.com/embed/xT9IgNPVbGsa0Wd8li"
                  width="250"
                  height="250"
                  frameBorder="0"
                  class="giphy-embed"
                  allowFullScreen
                ></iframe>
                <p>
                  <a
                    href="https://giphy.com/gifs/studiosoriginals-xT9IgNPVbGsa0Wd8li"
                  >
                    via GIPHY
                  </a>
                </p>
              </div>

              <p>
                Feel free to report any bugs to
                <app-main-author-email />
              </p>
              <p>
                Or directly from the
                <a
                  class="font-weight-bold"
                  href="https://github.com/carlomigueldy/supa"
                  target="_blank"
                >
                  repo
                </a>
              </p>
            </section>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <v-row>
      <v-col>
        <v-card outlined>
          <v-card-title>Roadmap</v-card-title>
          <v-divider />
          <v-card-text>
            <ul>
              <li>
                <p>Supabase Hackathon Submission 🎉</p>
              </li>
              <li>
                <p>When Nuxt 3 comes out this app will get updated.</p>
              </li>
              <li>
                <p>A complete TypeScript migration</p>
              </li>
              <li>
                <p>
                  Maybe a UI redesign? If you're a designer and willing to
                  redesign the entire open-source app for free then feel free to
                  reach me
                  <app-main-author-email />. Your name will be added into the
                  "Contributors" section
                </p>
              </li>
              <li>
                <p>
                  "Connect to Ronin Wallet" integration. We don't know how to do
                  it yet but let us know if you got any ideas
                </p>
              </li>
              <li>
                <p>
                  App Logo
                </p>
              </li>
              <li>
                <p>
                  Better landing page design
                </p>
              </li>
            </ul>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <v-row>
      <v-col>
        <v-card outlined>
          <v-card-title>Disclaimer</v-card-title>
          <v-divider />
          <v-card-text>
            <p>
              We are not affiliated with
              <a href="https://axieinfinity.com" target="_blank">
                Axie Infinity
              </a>
            </p>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <v-sheet color="transparent" height="30vh" />
  </app-main-container>
</template>

<script>
export default {
  head: {
    title: "About"
  },

  data: () => ({
    dialog: {
      review: false
    }
  })
};
</script>

<style></style>
