<template>
  <v-app dark>
    <v-navigation-drawer
      color="grey darken-4"
      :value="$store.state.drawer"
      fixed
      app
    >
      <v-list>
        <v-list-item
          v-for="(item, i) in items"
          :key="i"
          :to="item.to"
          router
          exact
        >
          <v-list-item-action>
            <v-icon>{{ item.icon }}</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title v-text="item.title" />
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
    <Nuxt />
  </v-app>
</template>

<script>
export default {
  data: () => ({
    drawer: true,
    items: [
      {
        icon: "mdi-apps",
        title: "Welcome",
        to: "/"
      },
      {
        icon: "mdi-apps",
        title: "Scholars",
        to: "/scholars"
      },
      {
        icon: "mdi-login",
        title: "Login",
        to: "/auth/login"
      },
      {
        icon: "mdi-plus",
        title: "Register",
        to: "/auth/register"
      }
    ],
    title: "Vuetify.js"
  })
};
</script>
