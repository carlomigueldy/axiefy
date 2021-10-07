<template>
  <app-main-container>
    <template v-slot:title>{{ title }}</template>
    <template v-slot:action>
      <v-btn depressed>Feedback</v-btn>
    </template>

    <v-row>
      <v-col>
        <v-alert border="left" color="deep-purple accent-4" dark>
          <div class="text-h6">Donate</div>
          <p>Donations are welcome</p>
          <v-btn
            href="https://www.buymeacoffee.com/carlomigueldy"
            depressed
            target="_blank"
          >
            Buy me a Coffee
          </v-btn>
        </v-alert>

        <v-card outlined>
          <v-card-title>Account</v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <v-sheet rounded color="transparent" width="200" height="200">
              <v-img
                src="supabase-logo.jpg"
                lazy-src="supabase-logo.jpg"
                class="rounded"
                width="200"
                height="200"
              >
                <template v-slot:placeholder>
                  <v-row
                    class="fill-height ma-0"
                    align="center"
                    justify="center"
                  >
                    <v-progress-circular
                      indeterminate
                      color="grey lighten-5"
                    ></v-progress-circular>
                  </v-row>
                </template>
              </v-img>
            </v-sheet>

            <v-sheet height="25" color="transparent"></v-sheet>

            <v-sheet width="325" class="my-5" color="transparent">
              <v-text-field label="Name" outlined dense></v-text-field>

              <v-text-field label="Email" outlined dense></v-text-field>
            </v-sheet>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <v-row>
      <v-col>
        <v-card id="billing" ref="billing" outlined>
          <v-card-title>Billing</v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <div class="subtitle-1">Coming soon</div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <v-row>
      <v-col>
        <v-card outlined>
          <v-card-title>Danger Zone</v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <div class="subtitle-1">Delete your account forever</div>
            <v-sheet height="25" color="transparent"></v-sheet>
            <v-btn depressed large color="error">Delete Account</v-btn>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <v-sheet height="300" color="transparent"></v-sheet>
  </app-main-container>
</template>

<script>
const TITLE = "Settings";

export default {
  head: {
    title: TITLE
  },

  mounted() {
    const { selector } = this.$route.query;

    if (selector) {
      this.$vuetify.goTo(this.$refs[selector]);
    }
  },

  computed: {
    title() {
      return TITLE;
    }
  }
};
</script>

<style></style>
