<template>
  <v-sheet
    height="100vh"
    width="100%"
    color="red"
    class="d-flex justify-space-between"
  >
    <v-sheet width="60%">
      <v-img
        src="https://images.pexels.com/photos/730564/pexels-photo-730564.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"
        width="100%"
        height="100%"
      />
    </v-sheet>
    <v-sheet class="d-flex justify-center align-center pa-5" width="40%">
      <v-card class="pa-0" width="100%" color="transparent" flat>
        <v-card-title class="display-1">Create Account</v-card-title>
        <v-card-subtitle>Manage your scholars</v-card-subtitle>

        <nuxt-child />
      </v-card>
    </v-sheet>
  </v-sheet>
</template>

<script>
export default {
  head: {
    title: "Create Account"
  },

  layout: "auth",

  auth: "guest"
};
</script>
