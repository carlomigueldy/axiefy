<template>
  <div>
    <v-app-bar
      style="backdrop-filter: blur(12px); background: transparent"
      :elevate-on-scroll="true"
      fixed
      app
    >
      <v-app-bar-nav-icon @click.stop="$store.commit('toggleDrawer')" />
      <div class="px-5 title">
        <slot name="title" />
      </div>
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
