<template>
  <v-app dark>
    <v-navigation-drawer
      color="grey darken-4"
      :value="$store.state.drawer"
      fixed
      app
    >
      <v-sheet color="transparent" class="px-3 py-1" width="100%">
        Hello World
      </v-sheet>

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

      <v-list-item
        @click="onClickUser"
        class="px-3 py-1"
        style="position: absolute; bottom: 0; left: 0; right: 0"
      >
        <v-list-item-avatar>
          <v-img src="supabase-logo.jpg"></v-img>
        </v-list-item-avatar>
        <v-list-item-content>
          <v-list-item-title>Carlo Miguel Dy</v-list-item-title>
          <v-list-item-subtitle>carlomigueldy@gmail.com</v-list-item-subtitle>
        </v-list-item-content>
      </v-list-item>
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
        title: "Scholars",
        to: "/scholars"
      }
    ],
    title: "Vuetify.js"
  }),

  methods: {
    onClickUser() {}
  }
};
</script>
