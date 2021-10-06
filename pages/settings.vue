<template>
  <app-main-container>
    <template v-slot:title>{{ title }}</template>

    <v-row>
      <v-col>
        <v-card outlined>
          <v-card-title>Profile</v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <!-- TODO: Refactor -->
            <v-sheet
              @click="null"
              rounded
              color="transparent"
              width="200"
              height="200"
            >
              <v-img
                src="https://upload.wikimedia.org/wikipedia/commons/5/5a/John_Doe%2C_born_John_Nommensen_Duchac.jpg"
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
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <v-row>
      <v-col>
        <v-card outlined>
          <v-card-title>Danger Zone</v-card-title>
          <v-divider></v-divider>
          <v-card-text>Delete your account forever</v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </app-main-container>
</template>

<script>
const TITLE = "Settings";

export default {
  head: {
    title: TITLE
  },

  computed: {
    title() {
      return TITLE;
    }
  }
};
</script>

<style></style>
