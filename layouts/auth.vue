<template>
  <v-app dark>
    <v-main>
      <v-container fluid class="pa-0" fill-height>
        <Nuxt />
      </v-container>
    </v-main>
    
    <lazy-app-snackbar />
  </v-app>
</template>

<script>
export default {
  auth: "guest",

  data() {
    return {};
  }
};
</script>
