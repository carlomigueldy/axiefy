<template>
  <app-main-container>
    <v-row>
      <v-col>
        <v-card flat outlined>
          <v-card-title>About</v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <p>
              An open-source software that aims to help NFT Game (e.g like
              <a
                href="axieinfinity.com"
                target="_blank"
                class="font-weight-bold"
              >
                "Axie Infinity"
              </a>
              ) Managers manage and track their scholars. While also being an
              entry to Supabase's 2nd Hackathon
              <a
                href="https://supabase.io/blog/2021/09/28/supabase-hacktoberfest-hackathon-2021"
                target="_blank"
                class="font-weight-bold"
              >
                "Supabase Hacktoberfest Hackathon 2021"
              </a>
            </p>

            <section class="mb-10 mt-10">
              <div class="subtitle-1 white--text">Core Contributors</div>
              <ul style="font-size: 16px">
                <li>
                  <a href="https://github.com/carlomigueldy" target="_blank">
                    carlomigueldy
                  </a>
                </li>
                <li>
                  <a href="https://github.com/sushiAlii" target="_blank">
                    sushiAlii
                  </a>
                </li>
              </ul>
            </section>

            <section class="mb-10">
              <div class="subtitle-1 white--text">Technology Stack & Usage</div>
              <ul style="font-size: 16px">
                <li>
                  <a href="https://supabase.io/" target="_blank"> Supabase </a>:
                  A serverless PostgreSQL database, also provides
                  zero-boilerplate for authentication and OAuth 2.0 integrations
                </li>
                <li>
                  <a href="https://vuejs.org/" target="_blank"> Vue.js </a>: A
                  Progressive JavaScript framework for building UI
                </li>
                <li>
                  <a href="https://nuxtjs.org/" target="_blank"> Nuxt.js </a>:
                  Vue.js framework for seamless app scaffolding and module
                  integrations
                </li>
                <li>
                  <a href="https://vuetifyjs.com/" target="_blank">
                    Vuetify.js </a
                  >: A Vue.js UI library using the Material Design System.
                  Perfect for developers who can't design or know well about UI
                  designs 😜
                </li>
              </ul>
            </section>

            <section class="mb-10">
              <div class="subtitle-1 white--text">Bugs / Issues</div>
              <p>
                Feel free to report any bugs to
                <a
                  class="font-weight-bold"
                  href="mailto:carlomigueldy@gmail.com"
                >
                  carlomigueldy@gmail.com
                </a>
              </p>
            </section>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </app-main-container>
</template>

<script>
export default {
  head: {
    title: "About"
  }
};
</script>

<style></style>
