<template>
  <div>
    <v-app-bar
      style="backdrop-filter: blur(12px); background: transparent"
      :elevate-on-scroll="true"
      fixed
      app
    >
      <v-app-bar-nav-icon @click.stop="$store.commit('toggleDrawer')" />
      <v-app-bar-title>
        <slot name="title" />
      </v-app-bar-title>
      <v-spacer></v-spacer>
      <div>
        <slot name="action" />
      </div>
    </v-app-bar>
    <v-main>
      <v-container>
        <slot />
      </v-container>
    </v-main>
  </div>
</template>

<script>
export default {};
</script>

<style></style>
